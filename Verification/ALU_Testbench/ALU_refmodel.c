#include <stdint.h>
#include "svdpi.h"

void ALU_refmodel(uint32_t SrcAE, uint32_t SrcBE, uint32_t ALUControlE,
             uint32_t *ALUResultE,
             svBit *Z, svBit *OV, svBit *CY, svBit *N,
             svBit *lts, svBit *ltu)
{
    uint64_t add_full = (uint64_t)SrcAE + (uint64_t)SrcBE;
    uint64_t sub_full = (uint64_t)SrcAE - (uint64_t)SrcBE;  // bit 32 set => borrow
    uint32_t sh = SrcBE & 0x1F;
    uint32_t r;

    *lts = ((int32_t)SrcAE < (int32_t)SrcBE);
    *ltu = (SrcAE < SrcBE);
    *Z   = (SrcAE == SrcBE);

    switch (ALUControlE & 0xF) {
        case 0x0: r = (uint32_t)add_full;                       break;
        case 0x1: r = (uint32_t)sub_full;                       break;
        case 0x2: r = SrcAE << sh;                              break;
        case 0x3: r = *lts;                                     break;
        case 0x4: r = *ltu;                                     break;
        case 0x5: r = SrcAE ^ SrcBE;                            break;
        case 0x6: r = SrcAE >> sh;                              break;
        case 0x7: r = (uint32_t)((int32_t)SrcAE >> sh);         break;
        case 0x8: r = SrcAE | SrcBE;                            break;
        case 0x9: r = SrcAE & SrcBE;                            break;
        default:  r = 0;                                        break;
    }

    *ALUResultE = r;
    *N = (r >> 31) & 1;

    if (ALUControlE == 0x0) {
        *OV = (((SrcAE ^ r) & (SrcBE ^ r)) >> 31) & 1;
        *CY = (add_full >> 32) & 1;
    } else if (ALUControlE == 0x1) {
        *OV = (((SrcAE ^ SrcBE) & (SrcAE ^ r)) >> 31) & 1;
        *CY = !((sub_full >> 32) & 1);          // 1 = no borrow
    } else {
        *OV = 0;
        *CY = 0;
    }
}