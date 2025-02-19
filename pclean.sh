#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

PRINT_MODE=false
for arg in "$@"; do
  case $arg in
    -p|--print)
      PRINT_MODE=true
      shift
      ;;
    -h|--help)
      echo -e "${WHITE}PILOT - Personal In-Laptop Organized Trash Eliminator${NC}"
      echo -e "Usage: ./pilot [options]"
      echo -e "Options:"
      echo -e "  -p, --print    Print what would be deleted without actually deleting"
      echo -e "  -h, --help     Show this help message"
      exit 0
      ;;
  esac
done

get_size() {
  size=$(du -sh "$1" 2>/dev/null | cut -f1)
  if [ -z "$size" ]; then
    echo "0"
  else
    echo "$size"
  fi
}

clean_location() {
  local location=$1
  local description=$2
  
  if [ -e "$location" ]; then
    size=$(get_size "$location")
    if [ "$PRINT_MODE" = true ]; then
      echo -e " ${YELLOW}│${NC} Would clean: $description ${WHITE}($size)${NC}"
    else
      echo -e " ${GREEN}│${NC} Cleaning: $description ${WHITE}($size)${NC}"
      rm -rf "$location" 2>/dev/null
    fi
    total_cleaned=$((total_cleaned + 1))
  fi
}

term_width=$(tput cols 2>/dev/null)
if [ -z "$term_width" ]; then
  term_width=80
fi

generate_line() {
  printf '%*s' "$((term_width-2))" | tr ' ' '─'
}

clear
echo -e "${BLUE}"
echo "┌─────────────────────────────────────────────────────┐"
echo "│                                                     │"
echo "│   ██████╗ ██╗██╗      ██████╗ ████████╗            │"
echo "│   ██╔══██╗██║██║     ██╔═══██╗╚══██╔══╝            │"
echo "│   ██████╔╝██║██║     ██║   ██║   ██║               │"
echo "│   ██╔═══╝ ██║██║     ██║   ██║   ██║               │"
echo "│   ██║     ██║███████╗╚██████╔╝   ██║               │"
echo "│   ╚═╝     ╚═╝╚══════╝ ╚═════╝    ╚═╝               │"
echo "│                                                     │"
echo "│   Personal In-Laptop Organized Trash Eliminator     │"
echo "└─────────────────────────────────────────────────────┘"
echo -e "${NC}"

echo -e "${WHITE}Initializing PILOT systems...${NC}"
sleep 1
echo -e "${WHITE}Calibrating sensors...${NC}"
sleep 0.5
echo -e "${WHITE}Starting scan sequence...${NC}"
sleep 1

total_cleaned=0
clean_start=$(date +%s)

line=$(generate_line)
echo -e "${BLUE}┌${line}┐${NC}"

echo -e "${BLUE}│${NC} ${WHITE}BROWSER CACHES${NC}"
clean_location "$HOME/.cache/google-chrome/Default/Cache" "Chrome cache"
clean_location "$HOME/.cache/google-chrome/Default/Code Cache" "Chrome code cache"
clean_location "$HOME/.config/google-chrome/Default/Service Worker" "Chrome service workers"
clean_location "$HOME/.cache/mozilla/firefox/*.default*/cache2" "Firefox cache"
clean_location "$HOME/.cache/BraveSoftware/Brave-Browser/Default/Cache" "Brave cache"

echo -e "${BLUE}│${NC} ${WHITE}APPLICATION CACHES${NC}"
clean_location "$HOME/.cache" "General cache directory"
clean_location "$HOME/.npm/_cacache" "NPM cache"
clean_location "$HOME/.config/Code/Cache" "VSCode cache"
clean_location "$HOME/.config/Code/CachedData" "VSCode cached data"
clean_location "$HOME/.config/discord/Cache" "Discord cache"
clean_location "$HOME/.config/Slack/Cache" "Slack cache"

echo -e "${BLUE}│${NC} ${WHITE}DEVELOPMENT CACHES${NC}"
clean_location "$HOME/.gradle/caches" "Gradle cache"
clean_location "$HOME/.m2/repository" "Maven cache"
clean_location "$HOME/.vscode-server/data/User/workspaceStorage" "VSCode workspaces"
clean_location "$HOME/.config/Code/User/workspaceStorage" "VSCode workspace storage"
clean_location "$HOME/.cache/yarn" "Yarn cache"
clean_location "$HOME/.stack" "Haskell Stack"
clean_location "$HOME/.cargo/registry" "Cargo registry"

echo -e "${BLUE}│${NC} ${WHITE}BUILD DIRECTORIES${NC}"
find "$HOME/Downloads" -type d -name "build" -o -name "cmake-build*" 2>/dev/null | while read dir; do
  if [ -d "$dir" ]; then
    size=$(get_size "$dir")
    if [ "$PRINT_MODE" = true ]; then
      echo -e " ${YELLOW}│${NC} Would clean: $(basename "$(dirname "$dir")")/$(basename "$dir") ${WHITE}($size)${NC}"
    else
      echo -e " ${GREEN}│${NC} Cleaning: $(basename "$(dirname "$dir")")/$(basename "$dir") ${WHITE}($size)${NC}"
      rm -rf "$dir" 2>/dev/null
    fi
    total_cleaned=$((total_cleaned + 1))
  fi
done

echo -e "${BLUE}│${NC} ${WHITE}TEMPORARY FILES${NC}"
find "$HOME/Downloads" -type f -mtime +30 2>/dev/null | while read file; do
  if [ -f "$file" ]; then
    size=$(get_size "$file")
    if [ "$PRINT_MODE" = true ]; then
      echo -e " ${YELLOW}│${NC} Would remove: $(basename "$file") ${WHITE}($size)${NC}"
    else
      echo -e " ${GREEN}│${NC} Removing: $(basename "$file") ${WHITE}($size)${NC}"
      rm -f "$file" 2>/dev/null
    fi
    total_cleaned=$((total_cleaned + 1))
  fi
done

echo -e "${BLUE}│${NC} ${WHITE}THUMBNAILS${NC}"
clean_location "$HOME/.thumbnails" "Thumbnails"
clean_location "$HOME/.cache/thumbnails" "Cached thumbnails"

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo -e "${BLUE}│${NC} ${WHITE}TRASH${NC}"
  clean_location "$HOME/.Trash" "macOS Trash"
fi

echo -e "${BLUE}│${NC} ${WHITE}USER TEMP FILES${NC}"
find /tmp -user $(whoami) -type f 2>/dev/null | while read file; do
  if [ -f "$file" ]; then
    size=$(get_size "$file")
    if [ "$PRINT_MODE" = true ]; then
      echo -e " ${YELLOW}│${NC} Would remove: $(basename "$file") ${WHITE}($size)${NC}"
    else
      echo -e " ${GREEN}│${NC} Removing: $(basename "$file") ${WHITE}($size)${NC}"
      rm -f "$file" 2>/dev/null
    fi
    total_cleaned=$((total_cleaned + 1))
  fi
done

clean_end=$(date +%s)
clean_time=$((clean_end - clean_start))

echo -e "${BLUE}└${line}┘${NC}"

echo -e "\n${WHITE}Calculating results...${NC}"
sleep 1
echo -e "${WHITE}Generating report...${NC}"
sleep 0.5

if [ "$PRINT_MODE" = true ]; then
  echo -e "\n${YELLOW}┌─────────────────────────────────────────────────────┐${NC}"
  echo -e "${YELLOW}│${NC}    ${WHITE}PILOT SCAN COMPLETE - DRY RUN${NC}                  ${YELLOW}│${NC}"
  echo -e "${YELLOW}│${NC}    ${WHITE}Items that would be cleaned:${NC} $total_cleaned                ${YELLOW}│${NC}"
  echo -e "${YELLOW}│${NC}    ${WHITE}Scan completed in:${NC} ${clean_time}s                           ${YELLOW}│${NC}"
  echo -e "${YELLOW}└─────────────────────────────────────────────────────┘${NC}"
else
  disk_used=$(df -h ~ | awk 'NR==2 {print $5}' | tr -d '%')
  disk_avail=$(df -h ~ | awk 'NR==2 {print $4}')
  
  echo -e "\n${GREEN}┌─────────────────────────────────────────────────────┐${NC}"
  echo -e "${GREEN}│${NC}    ${WHITE}PILOT MISSION COMPLETE${NC}                         ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}    ${WHITE}Items cleaned:${NC} $total_cleaned                              ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}    ${WHITE}Cleanup completed in:${NC} ${clean_time}s                        ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}    ${WHITE}Current disk usage:${NC} ${disk_used}%                         ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}    ${WHITE}Available space:${NC} ${disk_avail}                          ${GREEN}│${NC}"
  echo -e "${GREEN}└─────────────────────────────────────────────────────┘${NC}"
fi

sleep 0.5
echo -e "\n${BLUE}PILOT${NC} signing off... ${GREEN}✓${NC}\n"
