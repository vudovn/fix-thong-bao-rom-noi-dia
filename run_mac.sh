#!/usr/bin/env bash

# ==============================================================================
# TOOL FIX THÔNG BÁO & DỌN APP RÁC CHO ĐIỆN THOẠI ROM NỘI ĐỊA TRUNG QUỐC
# Hỗ trợ: macOS & Linux
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clear
echo -e "${CYAN}======================================================================${NC}"
echo -e "${GREEN}    CÔNG CỤ FIX THÔNG BÁO & DỌN RÁC ANDROID ROM NỘI ĐỊA TRUNG QUỐC   ${NC}"
echo -e "${YELLOW}           Dành cho các dòng máy xách tay tại Việt Nam                ${NC}"
echo -e "${CYAN}======================================================================${NC}"
echo ""

while true; do
    echo -e "${YELLOW}VUI LÒNG CHỌN HÃNG ĐIỆN THOẠI CỦA BẠN:${NC}"
    echo -e "  ${GREEN}[1] 🟢 OPPO / OnePlus / Realme${NC} (ColorOS / OxygenOS / RealmeUI) ${GREEN}[SẴN SÀNG]${NC}"
    echo -e "  ${YELLOW}[2] 🟡 Xiaomi / Redmi / POCO${NC} (HyperOS / MIUI) ${YELLOW}[Đang phát triển]${NC}"
    echo -e "  ${YELLOW}[3] 🟡 Vivo / iQOO${NC} (OriginOS / FuntouchOS) ${YELLOW}[Đang phát triển]${NC}"
    echo -e "  ${RED}[0] ❌ Thoát${NC}"
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    read -p "Nhập lựa chọn của bạn [0-3]: " brand_choice

    case $brand_choice in
        1)
            echo -e "\n${BLUE}▶ Đang khởi động bộ công cụ cho OPPO / OnePlus / Realme...${NC}\n"
            cd "$SCRIPT_DIR/oppo-oneplus-realme"
            chmod +x run_mac.sh
            ./run_mac.sh
            cd "$SCRIPT_DIR"
            ;;
        2)
            echo -e "\n${YELLOW}🚧 Module Xiaomi / Redmi (HyperOS / MIUI) đang được hoàn thiện!${NC}"
            echo -e "Hãy theo dõi cập nhật mới nhất trên GitHub repository.\n"
            read -p "Nhấn [Enter] để quay lại menu..."
            clear
            ;;
        3)
            echo -e "\n${YELLOW}🚧 Module Vivo / iQOO (OriginOS) đang được hoàn thiện!${NC}"
            echo -e "Hãy theo dõi cập nhật mới nhất trên GitHub repository.\n"
            read -p "Nhấn [Enter] để quay lại menu..."
            clear
            ;;
        0)
            echo -e "\n${GREEN}Cảm ơn bạn đã sử dụng tool! Tạm biệt!${NC}\n"
            exit 0
            ;;
        *)
            echo -e "${RED}Lựa chọn không hợp lệ, vui lòng chọn từ 0 đến 3!${NC}\n"
            ;;
    esac
done
