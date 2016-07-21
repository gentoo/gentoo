/*
 * UAE - The Un*x Amiga Emulator
 *
 * SDL graphics support
 *
 * Copyright 2004 Richard Drummond
 */

/*
 * What graphics platform are we running on . . .?
 *
 * Yes, SDL is supposed to abstract away from the underlying
 * platform, but we need to know this to be able to map raw keys
 * and to work around any platform-specific quirks . . .
 */
enum {
    SDLGFX_DRIVER_UNKNOWN,
    SDLGFX_DRIVER_X11,
    SDLGFX_DRIVER_DGA,
    SDLGFX_DRIVER_SVGALIB,
    SDLGFX_DRIVER_FBCON,
    SDLGFX_DRIVER_DIRECTFB,
    SDLGFX_DRIVER_QUARTZ,
    SDLGFX_DRIVER_BWINDOW,
    SDLGFX_DRIVER_CYBERGFX,
    SDLGFX_DRIVER_AMIGAOS4
};

extern int get_sdlgfx_type (void);

/* keyboard support */
struct uae_input_device_kbr_default *get_default_raw_keymap (int type);
extern int keysym2amiga (int keycode);
int modifier_hack (int *scancode, int *pressed);

/* hotkey support */
struct uae_hotkeyseq *get_default_cooked_hotkeys (void);
struct uae_hotkeyseq *get_default_raw_hotkeys (void);
