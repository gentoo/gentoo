# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Meta package containing deps on all xorg drivers"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"

IUSE_INPUT_DEVICES="
	input_devices_acecad
	input_devices_aiptek
	input_devices_elographics
	input_devices_evdev
	input_devices_fpit
	input_devices_hyperpen
	input_devices_joystick
	input_devices_keyboard
	input_devices_libinput
	input_devices_mouse
	input_devices_mutouch
	input_devices_penmount
	input_devices_tslib
	input_devices_vmmouse
	input_devices_void
	input_devices_synaptics
	input_devices_wacom
"
IUSE_VIDEO_CARDS="
	video_cards_amdgpu
	video_cards_apm
	video_cards_ast
	video_cards_chips
	video_cards_cirrus
	video_cards_dummy
	video_cards_epson
	video_cards_fbdev
	video_cards_freedreno
	video_cards_geode
	video_cards_glint
	video_cards_i128
	video_cards_i740
	video_cards_intel
	video_cards_mach64
	video_cards_mga
	video_cards_neomagic
	video_cards_nouveau
	video_cards_nv
	video_cards_omap
	video_cards_omapfb
	video_cards_qxl
	video_cards_r128
	video_cards_radeon
	video_cards_radeonsi
	video_cards_rendition
	video_cards_s3
	video_cards_s3virge
	video_cards_savage
	video_cards_siliconmotion
	video_cards_sisusb
	video_cards_sunbw2
	video_cards_suncg14
	video_cards_suncg3
	video_cards_suncg6
	video_cards_sunffb
	video_cards_sunleo
	video_cards_suntcx
	video_cards_tdfx
	video_cards_tegra
	video_cards_tga
	video_cards_trident
	video_cards_tseng
	video_cards_vesa
	video_cards_via
	video_cards_virtualbox
	video_cards_vmware
	video_cards_voodoo
	video_cards_fglrx
	video_cards_nvidia
"

IUSE="${IUSE_VIDEO_CARDS} ${IUSE_INPUT_DEVICES}"

PDEPEND="
	input_devices_acecad?      ( x11-drivers/xf86-input-acecad )
	input_devices_aiptek?      ( x11-drivers/xf86-input-aiptek )
	input_devices_elographics? ( x11-drivers/xf86-input-elographics )
	input_devices_evdev?       ( x11-drivers/xf86-input-evdev )
	input_devices_fpit?        ( x11-drivers/xf86-input-fpit )
	input_devices_hyperpen?    ( x11-drivers/xf86-input-hyperpen )
	input_devices_joystick?    ( x11-drivers/xf86-input-joystick )
	input_devices_keyboard?    ( x11-drivers/xf86-input-keyboard )
	input_devices_libinput?    ( x11-drivers/xf86-input-libinput )
	input_devices_mouse?       ( x11-drivers/xf86-input-mouse )
	input_devices_mutouch?     ( x11-drivers/xf86-input-mutouch )
	input_devices_penmount?    ( x11-drivers/xf86-input-penmount )
	input_devices_tslib?       ( x11-drivers/xf86-input-tslib )
	input_devices_vmmouse?     ( x11-drivers/xf86-input-vmmouse )
	input_devices_void?        ( x11-drivers/xf86-input-void )
	input_devices_synaptics?   ( x11-drivers/xf86-input-synaptics )
	input_devices_wacom?       ( x11-drivers/xf86-input-wacom )

	video_cards_amdgpu?        ( x11-drivers/xf86-video-amdgpu )
	video_cards_apm?           ( x11-drivers/xf86-video-apm )
	video_cards_ast?           ( x11-drivers/xf86-video-ast )
	video_cards_chips?         ( x11-drivers/xf86-video-chips )
	video_cards_cirrus?        ( x11-drivers/xf86-video-cirrus )
	video_cards_dummy?         ( x11-drivers/xf86-video-dummy )
	video_cards_fbdev?         ( x11-drivers/xf86-video-fbdev )
	video_cards_freedreno?     ( x11-drivers/xf86-video-freedreno )
	video_cards_geode?         ( x11-drivers/xf86-video-geode )
	video_cards_glint?         ( x11-drivers/xf86-video-glint )
	video_cards_i128?          ( x11-drivers/xf86-video-i128 )
	video_cards_i740?          ( x11-drivers/xf86-video-i740 )
	video_cards_intel?         ( x11-drivers/xf86-video-intel )
	video_cards_mach64?        ( x11-drivers/xf86-video-mach64 )
	video_cards_mga?           ( x11-drivers/xf86-video-mga )
	video_cards_neomagic?      ( x11-drivers/xf86-video-neomagic )
	video_cards_nouveau?       ( x11-drivers/xf86-video-nouveau )
	video_cards_nv?            ( x11-drivers/xf86-video-nv )
	video_cards_omap?          ( x11-drivers/xf86-video-omap )
	video_cards_omapfb?        ( x11-drivers/xf86-video-omapfb )
	video_cards_qxl?           ( x11-drivers/xf86-video-qxl )
	video_cards_nvidia?        ( x11-drivers/nvidia-drivers )
	video_cards_fglrx?         ( x11-drivers/ati-drivers )
	video_cards_r128?          ( x11-drivers/xf86-video-r128 )
	video_cards_radeon?        ( x11-drivers/xf86-video-ati )
	video_cards_radeonsi?      ( x11-drivers/xf86-video-ati[glamor] )
	video_cards_rendition?     ( x11-drivers/xf86-video-rendition )
	video_cards_s3?            ( x11-drivers/xf86-video-s3 )
	video_cards_s3virge?       ( x11-drivers/xf86-video-s3virge )
	video_cards_savage?        ( x11-drivers/xf86-video-savage )
	video_cards_siliconmotion? ( x11-drivers/xf86-video-siliconmotion )
	video_cards_sisusb?        ( x11-drivers/xf86-video-sisusb )
	video_cards_suncg14?       ( x11-drivers/xf86-video-suncg14 )
	video_cards_suncg3?        ( x11-drivers/xf86-video-suncg3 )
	video_cards_suncg6?        ( x11-drivers/xf86-video-suncg6 )
	video_cards_sunffb?        ( x11-drivers/xf86-video-sunffb )
	video_cards_sunleo?        ( x11-drivers/xf86-video-sunleo )
	video_cards_suntcx?        ( x11-drivers/xf86-video-suntcx )
	video_cards_tdfx?          ( x11-drivers/xf86-video-tdfx )
	video_cards_tegra?         ( x11-drivers/xf86-video-opentegra )
	video_cards_tga?           ( x11-drivers/xf86-video-tga )
	video_cards_trident?       ( x11-drivers/xf86-video-trident )
	video_cards_tseng?         ( x11-drivers/xf86-video-tseng )
	video_cards_vesa?          ( x11-drivers/xf86-video-vesa )
	video_cards_via?           ( x11-drivers/xf86-video-openchrome )
	video_cards_virtualbox?    ( x11-drivers/xf86-video-virtualbox )
	video_cards_vmware?        ( x11-drivers/xf86-video-vmware )
	video_cards_voodoo?        ( x11-drivers/xf86-video-voodoo )

	!x11-drivers/xf86-input-citron
	!x11-drivers/xf86-video-cyrix
	!x11-drivers/xf86-video-impact
	!x11-drivers/xf86-video-nsc
	!x11-drivers/xf86-video-sunbw2
	!<=x11-drivers/xf86-video-ark-0.7.5
	!<=x11-drivers/xf86-video-newport-0.2.4
	!<=x11-drivers/xf86-video-sis-0.10.7
	!<=x11-drivers/xf86-video-v4l-0.2.0
	!<x11-drivers/xf86-input-evdev-2.10.0
	!<x11-drivers/xf86-video-ati-7.6.1
	!<x11-drivers/xf86-video-intel-2.99.917_p20160122
	!<x11-drivers/xf86-video-nouveau-1.0.12
"
