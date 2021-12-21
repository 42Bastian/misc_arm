/* Setup 565 RGB LUT for pen 0..3 */
void initLut()
{
  static const uint32_t colors[] = {
    0,
    0x00A55A00,
    0x00E99E45,
    0x00FFE289
  };
  uint32_t i;
  uint8_t r;
  uint8_t b;
  uint8_t g;
  for(i = 0; i < 4; ++i){
    LCDIF->LUT0_ADDR = i;
    r = (colors[i] >> (16+3)) & 0x1f;
    g = (colors[i] >> (8+2)) & 0x3f;
    b = (colors[i] >> 3) & 0x1f;
    LCDIF->LUT0_DATA = (r<<11) | b | (g<<5);
  }
}

extern void mona(uint32_t fb);
extern uint8_t frameBuffer[];

SC_PROCESS(mona_p)
{
  initLut();
  mona((uint32_t)frameBuffer);
  for(;;) sc_procStop(SC_CURRENT_PID);
}
