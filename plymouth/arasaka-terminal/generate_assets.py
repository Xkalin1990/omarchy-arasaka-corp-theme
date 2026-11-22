#!/usr/bin/env python3
"""Generate ultra-crisp PNG assets for the Arasaka Terminal Plymouth theme."""

import os
import subprocess
from PIL import Image, ImageDraw, ImageFont

OUT_DIR = os.path.dirname(os.path.abspath(__file__))

BG_COLOR = (17, 13, 14)         # #110d0e
BOX_BG = (14, 10, 11)           # #0e0a0b
RED = "#e50000"
RED_RGB = (229, 0, 0)
DIM_RED_RGB = (175, 0, 0)
WHITE = "#f0f0f0"
GREY_RGB = (176, 176, 176)
LABEL_GREY_RGB = (168, 168, 168)

FONT_MONO = "/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf"
FONT_MONO_BOLD = "/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Bold.ttf"
FONT_JP = "/usr/share/fonts/noto-cjk/NotoSansCJK-Regular.ttc"

# Fallback font discovery if exact paths differ
def find_font(preferred, fc_pattern):
    if os.path.exists(preferred):
        return preferred
    out = subprocess.check_output(["fc-match", "-f", "%{file}", fc_pattern], text=True).strip()
    return out


def svg_to_png(svg_code: str, out_path: str, width: int, height: int):
    svg_path = out_path + ".tmp.svg"
    with open(svg_path, "w") as f:
        f.write(svg_code)
    subprocess.run(
        ["rsvg-convert", "-w", str(width), "-h", str(height), svg_path, "-o", out_path],
        check=True,
    )
    os.remove(svg_path)


def make_pixel(filename: str, rgba: tuple):
    im = Image.new("RGBA", (1, 1), rgba)
    im.save(os.path.join(OUT_DIR, filename))


def arasaka_mon_svg(color: str) -> str:
    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">
  <circle cx="100" cy="100" r="88" fill="none" stroke="{color}" stroke-width="13"/>
  <rect x="93" y="60" width="14" height="122" fill="{color}"/>
  <line x1="100" y1="138" x2="52" y2="96" stroke="{color}" stroke-width="13" stroke-linecap="round"/>
  <line x1="100" y1="138" x2="148" y2="96" stroke="{color}" stroke-width="13" stroke-linecap="round"/>
  <circle cx="100" cy="56" r="24" fill="{color}"/>
  <circle cx="52" cy="96" r="24" fill="{color}"/>
  <circle cx="148" cy="96" r="24" fill="{color}"/>
</svg>"""


def arasaka_wordmark_svg(color: str) -> str:
    """Exact Cyberpunk 2077 'arasaka' wordmark vector traced from arasakabootlogo.jpg."""
    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="2 2 676 95">
  <path fill="{color}" fill-rule="evenodd" d="M 70.50,3.00 L 47.75,3.25 L 42.25,4.00 L 33.00,7.00 L 28.50,9.25 L 22.50,13.25 L 18.00,17.00 L 14.00,21.25 L 10.50,26.00 L 7.00,32.25 L 4.25,40.00 L 3.25,47.25 L 3.25,52.50 L 5.25,63.75 L 6.00,64.50 L 6.25,66.25 L 9.00,72.25 L 14.25,79.75 L 20.25,85.50 L 26.25,89.75 L 35.75,94.00 L 44.00,96.00 L 71.25,96.50 L 73.00,96.00 L 73.00,81.00 L 65.75,73.75 L 64.25,73.00 L 51.25,73.25 L 44.50,71.75 L 36.50,67.75 L 34.25,66.00 L 31.25,62.50 L 29.00,59.00 L 27.25,52.50 L 27.25,47.00 L 28.00,43.25 L 31.00,37.00 L 36.25,32.00 L 44.25,28.00 L 52.00,26.25 L 61.50,26.50 L 74.00,38.25 L 77.00,41.75 L 77.00,96.00 L 78.25,96.50 L 100.75,96.00 L 100.75,32.00 L 100.25,31.00 L 93.50,25.00 L 88.00,19.00 L 78.75,10.50 L 78.75,10.00 L 71.50,3.25 Z M 352.50,3.00 L 351.00,3.75 L 350.75,28.50 L 309.25,28.50 L 309.75,29.75 L 312.75,31.25 L 337.25,48.00 L 338.00,48.00 L 341.25,50.75 L 344.25,52.25 L 347.25,54.75 L 348.75,55.25 L 350.25,56.75 L 351.75,57.25 L 353.25,58.75 L 363.75,65.25 L 364.50,66.25 L 372.25,71.00 L 373.00,72.00 L 373.00,72.75 L 339.25,72.50 L 337.00,72.00 L 335.00,70.50 L 333.25,66.75 L 333.25,57.00 L 332.75,56.25 L 310.25,56.25 L 309.50,57.50 L 309.50,75.50 L 310.25,81.25 L 313.00,88.00 L 316.25,92.00 L 321.00,95.00 L 326.75,96.25 L 335.00,96.25 L 410.25,96.25 L 410.75,95.75 L 410.75,68.25 L 404.25,64.00 L 403.50,63.00 L 402.75,63.00 L 397.75,59.25 L 396.25,58.75 L 393.00,56.00 L 392.25,56.00 L 388.75,53.25 L 387.25,52.75 L 387.25,52.25 L 384.75,51.00 L 384.00,50.00 L 383.25,50.00 L 380.25,48.00 L 379.50,47.00 L 378.75,47.00 L 352.50,29.50 L 352.50,28.50 L 353.00,28.25 L 400.50,28.25 L 401.00,27.75 L 400.75,19.75 L 383.50,6.00 L 381.25,4.75 L 380.00,3.25 Z M 475.00,3.00 L 452.25,3.25 L 449.75,4.00 L 447.25,4.00 L 436.00,8.00 L 435.50,8.75 L 433.75,9.25 L 428.25,12.75 L 420.00,20.25 L 413.25,30.00 L 411.00,35.00 L 409.00,42.50 L 408.50,51.50 L 409.75,61.00 L 413.00,70.00 L 419.50,79.75 L 428.25,87.75 L 438.00,93.00 L 444.00,95.00 L 449.00,96.00 L 477.00,96.50 L 478.25,95.75 L 478.00,80.50 L 470.25,73.25 L 454.25,73.00 L 449.75,71.75 L 444.50,69.50 L 440.25,66.75 L 436.75,63.25 L 435.75,61.25 L 433.25,57.00 L 432.25,52.00 L 432.25,47.25 L 434.25,40.25 L 437.75,35.25 L 441.00,32.25 L 442.50,31.75 L 444.25,30.25 L 451.50,27.25 L 455.50,26.50 L 466.50,26.50 L 482.00,41.50 L 482.00,95.75 L 483.50,96.50 L 504.00,96.50 L 506.00,95.75 L 506.00,32.00 L 498.25,24.00 L 491.00,17.50 L 489.75,15.75 L 484.00,10.75 L 480.75,7.00 L 477.25,3.75 Z M 509.00,3.00 L 508.00,3.50 L 508.00,56.75 L 515.00,61.25 L 516.25,62.75 L 515.75,63.25 L 508.50,63.00 L 508.00,63.50 L 508.00,78.75 L 508.50,79.25 L 531.25,79.25 L 532.00,77.00 L 531.75,74.00 L 532.25,73.25 L 533.00,73.25 L 540.50,78.75 L 547.75,83.00 L 553.00,87.00 L 567.50,96.25 L 609.25,96.25 L 609.50,95.50 L 609.00,95.00 L 608.25,95.00 L 599.75,89.00 L 599.00,89.00 L 596.75,87.00 L 596.00,87.00 L 592.25,84.00 L 589.75,82.75 L 589.75,82.25 L 588.50,82.00 L 587.75,81.00 L 563.50,65.00 L 551.75,57.00 L 551.00,57.00 L 544.75,52.25 L 543.50,52.00 L 542.75,51.00 L 541.75,50.75 L 541.00,49.50 L 579.00,24.00 L 579.75,24.00 L 586.50,19.00 L 590.25,17.00 L 591.00,16.00 L 594.00,14.50 L 603.00,8.00 L 603.75,8.00 L 605.50,6.25 L 608.75,4.75 L 609.75,3.25 L 567.25,3.25 L 533.50,26.00 L 532.00,26.25 L 531.75,3.50 L 530.75,3.00 Z M 646.00,3.00 L 623.25,3.25 L 622.25,3.75 L 618.00,4.00 L 608.25,7.25 L 604.25,9.25 L 603.75,10.00 L 602.50,10.25 L 601.75,11.25 L 597.25,14.00 L 589.00,22.25 L 583.25,31.25 L 580.00,40.75 L 579.25,45.25 L 579.25,54.50 L 581.25,64.00 L 583.00,68.50 L 586.25,74.50 L 591.00,80.75 L 591.75,81.00 L 594.00,83.75 L 597.75,86.25 L 598.00,87.00 L 600.75,88.25 L 601.00,89.00 L 611.25,94.00 L 619.75,96.00 L 644.00,96.50 L 649.00,96.00 L 649.00,81.25 L 641.00,73.25 L 625.00,73.00 L 620.25,71.75 L 612.25,67.75 L 608.25,64.25 L 606.50,61.50 L 604.00,57.00 L 603.00,52.00 L 603.00,47.75 L 605.00,40.00 L 608.00,35.75 L 612.00,32.00 L 620.75,27.75 L 627.50,26.25 L 637.25,26.50 L 647.75,36.25 L 647.75,36.75 L 652.00,40.50 L 653.00,42.25 L 652.75,95.75 L 654.25,96.50 L 676.00,96.25 L 676.75,95.75 L 676.75,32.25 L 676.25,31.25 L 664.25,20.00 L 661.00,16.25 L 656.00,12.00 L 651.75,7.25 L 648.50,4.75 L 647.75,3.50 Z M 105.75,3.25 L 105.25,3.50 L 105.00,25.25 L 105.25,56.50 L 106.25,57.75 L 107.75,58.25 L 113.25,62.00 L 113.50,63.00 L 105.50,63.25 L 105.25,78.75 L 105.75,79.25 L 128.75,79.25 L 129.25,76.25 L 129.00,73.75 L 130.00,73.25 L 164.25,96.25 L 205.50,96.50 L 206.75,95.75 L 206.25,95.00 L 205.00,94.75 L 191.50,85.75 L 190.00,84.25 L 188.50,83.75 L 160.00,64.75 L 129.25,44.00 L 129.25,27.50 L 130.25,27.00 L 177.50,27.25 L 180.25,28.50 L 182.00,30.75 L 182.50,32.50 L 182.75,43.00 L 206.00,43.00 L 206.00,20.25 L 204.25,14.25 L 200.50,8.50 L 195.75,5.00 L 189.50,3.25 Z M 251.75,3.25 L 242.50,5.00 L 241.50,5.75 L 236.50,7.25 L 229.25,11.25 L 223.25,16.00 L 215.75,24.25 L 211.00,32.50 L 208.25,40.75 L 207.50,46.25 L 207.50,53.25 L 208.75,61.25 L 212.00,70.00 L 217.00,78.00 L 224.00,85.25 L 232.25,90.75 L 236.25,92.75 L 241.75,94.25 L 242.75,95.00 L 248.25,96.00 L 277.00,96.25 L 277.25,95.75 L 277.25,81.25 L 276.75,80.25 L 269.75,73.75 L 268.75,73.00 L 253.50,73.00 L 248.50,71.75 L 242.50,69.00 L 236.00,63.75 L 236.00,63.00 L 234.00,60.75 L 232.00,56.25 L 231.25,52.00 L 231.25,47.75 L 232.25,43.50 L 233.25,40.00 L 236.00,36.00 L 240.50,32.00 L 244.25,29.75 L 254.00,26.50 L 264.50,26.25 L 266.00,26.75 L 275.75,36.00 L 281.00,41.75 L 281.00,96.00 L 282.50,96.50 L 300.50,96.50 L 304.50,96.25 L 305.00,95.75 L 304.75,31.50 L 292.25,19.75 L 287.75,14.75 L 285.25,13.00 L 275.75,3.25 Z"/>
</svg>"""


def main():
    mono_reg = find_font(FONT_MONO, "JetBrainsMono Nerd Font:style=Regular")
    mono_bold = find_font(FONT_MONO_BOLD, "JetBrainsMono Nerd Font:style=Bold")
    jp_font = find_font(FONT_JP, "Noto Sans CJK JP:style=Regular")

    # 1. Pixel sprites
    make_pixel("red_pixel.png", (*RED_RGB, 255))
    make_pixel("dim_red_pixel.png", (*DIM_RED_RGB, 255))
    make_pixel("box_bg_pixel.png", (*BOX_BG, 255))
    make_pixel("grey_pixel.png", (*GREY_RGB, 255))

    # 2. Main Arasaka Emblem (250x250)
    svg_to_png(arasaka_mon_svg(RED), os.path.join(OUT_DIR, "arasaka_emblem.png"), 250, 250)

    # 3. Main Arasaka Wordmark + CORPORATION (256x76)
    wm_tmp = os.path.join(OUT_DIR, "_wm_tmp.png")
    svg_to_png(arasaka_wordmark_svg(WHITE), wm_tmp, 252, 35)
    wm_img = Image.open(wm_tmp).convert("RGBA")
    os.remove(wm_tmp)

    wordmark_canvas = Image.new("RGBA", (256, 72), (0, 0, 0, 0))
    wordmark_canvas.paste(wm_img, (2, 0), wm_img)
    draw = ImageDraw.Draw(wordmark_canvas)
    corp_font = ImageFont.truetype(mono_reg, 17)
    corp_text = "C O R P O R A T I O N"
    bbox = draw.textbbox((0, 0), corp_text, font=corp_font)
    tw = bbox[2] - bbox[0]
    draw.text(((256 - tw) // 2, 42), corp_text, font=corp_font, fill=(180, 180, 180, 255))
    wordmark_canvas.save(os.path.join(OUT_DIR, "arasaka_wordmark.png"))

    # 4. Vertical bottom-left OS version text (rotated 90 deg CCW)
    ver_font = ImageFont.truetype(mono_reg, 15)
    ver_text = "ARASAKA OS V024.11.880"
    tmp = Image.new("RGBA", (400, 40), (0, 0, 0, 0))
    d = ImageDraw.Draw(tmp)
    vb = d.textbbox((0, 0), ver_text, font=ver_font)
    d.text((0, 0), ver_text, font=ver_font, fill=(*RED_RGB, 255))
    cropped = tmp.crop((vb[0], vb[1], vb[2] + 2, vb[3] + 2))
    rotated = cropped.rotate(90, expand=True)
    rotated.save(os.path.join(OUT_DIR, "version_vert.png"))

    # 5. Bottom-right Arasaka corner badge (small mon + arasaka + line + アラサカ社)
    c_mon_tmp = os.path.join(OUT_DIR, "_c_mon.png")
    c_wm_tmp = os.path.join(OUT_DIR, "_c_wm.png")
    svg_to_png(arasaka_mon_svg(RED), c_mon_tmp, 26, 26)
    svg_to_png(arasaka_wordmark_svg(RED), c_wm_tmp, 156, 22)
    c_mon = Image.open(c_mon_tmp).convert("RGBA")
    c_wm = Image.open(c_wm_tmp).convert("RGBA")
    os.remove(c_mon_tmp)
    os.remove(c_wm_tmp)

    corner = Image.new("RGBA", (192, 54), (0, 0, 0, 0))
    corner.paste(c_mon, (0, 0), c_mon)
    corner.paste(c_wm, (32, 2), c_wm)
    cd = ImageDraw.Draw(corner)
    jp = ImageFont.truetype(jp_font, 16)
    jb = cd.textbbox((0, 0), "アラサカ社", font=jp)
    jw = jb[2] - jb[0]
    jp_x = 192 - jw - 2
    # Thin horizontal line on the left of アラサカ社
    cd.line([(2, 39), (jp_x - 10, 39)], fill=(158, 158, 158, 255), width=2)
    cd.text((jp_x, 27), "アラサカ社", font=jp, fill=(205, 205, 205, 255))
    corner.save(os.path.join(OUT_DIR, "arasaka_corner.png"))

    # 6. Diagonal slashes + horizontal line (480x16)
    slashes_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 480 16">
  <g stroke="#b8b8b8" stroke-width="2.2">
    <line x1="2" y1="14" x2="10" y2="2"/>
    <line x1="12" y1="14" x2="20" y2="2"/>
    <line x1="22" y1="14" x2="30" y2="2"/>
    <line x1="32" y1="14" x2="40" y2="2"/>
    <line x1="42" y1="14" x2="50" y2="2"/>
    <line x1="52" y1="14" x2="60" y2="2"/>
    <line x1="62" y1="14" x2="70" y2="2"/>
    <line x1="72" y1="14" x2="80" y2="2"/>
    <line x1="82" y1="14" x2="90" y2="2"/>
    <line x1="92" y1="14" x2="100" y2="2"/>
    <line x1="102" y1="14" x2="110" y2="2"/>
    <line x1="126" y1="8" x2="480" y2="8" stroke-width="1.6"/>
  </g>
</svg>"""
    svg_to_png(slashes_svg, os.path.join(OUT_DIR, "slashes_bar.png"), 480, 16)

    # 7. Network info block (boot mode)
    net_img = Image.new("RGBA", (480, 52), (0, 0, 0, 0))
    nd = ImageDraw.Draw(net_img)
    net_font = ImageFont.truetype(mono_bold, 16)
    l1_a = "CURR_NETWORK: "
    l1_b = "ACN002077"
    l2_a = "NL_PORT_STATUS: "
    l2_b = "OPEN"
    nd.text((0, 0), l1_a, font=net_font, fill=(*LABEL_GREY_RGB, 255))
    w1 = nd.textlength(l1_a, font=net_font)
    nd.text((w1, 0), l1_b, font=net_font, fill=(*RED_RGB, 255))

    nd.text((0, 26), l2_a, font=net_font, fill=(*LABEL_GREY_RGB, 255))
    w2 = nd.textlength(l2_a, font=net_font)
    nd.text((w2, 26), l2_b, font=net_font, fill=(*RED_RGB, 255))
    net_img.save(os.path.join(OUT_DIR, "network_info.png"))

    # 8. Network info block (shutdown/reboot mode)
    net_off = Image.new("RGBA", (480, 52), (0, 0, 0, 0))
    nod = ImageDraw.Draw(net_off)
    l2_b_off = "CLOSING"
    nod.text((0, 0), l1_a, font=net_font, fill=(*LABEL_GREY_RGB, 255))
    nod.text((w1, 0), l1_b, font=net_font, fill=(*RED_RGB, 255))
    nod.text((0, 26), l2_a, font=net_font, fill=(*LABEL_GREY_RGB, 255))
    nod.text((w2, 26), l2_b_off, font=net_font, fill=(*RED_RGB, 255))
    net_off.save(os.path.join(OUT_DIR, "network_info_off.png"))

    print("Generated all assets in", OUT_DIR)


if __name__ == "__main__":
    main()
