# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package containing deps on all xorg drivers"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

IUSE_INPUT_DEVICES="
	input_devices_elographics
	input_devices_evdev
	input_devices_joystick
	input_devices_libinput
	input_devices_vmmouse
	input_devices_void
	input_devices_synaptics
	input_devices_wacom
"
IUSE_VIDEO_CARDS="
	video_cards_amdgpu
	video_cards_ast
	video_cards_dummy
	video_cards_fbdev
	video_cards_freedreno
	video_cards_geode
	video_cards_glint
	video_cards_i915
	video_cards_i965
	video_cards_intel
	video_cards_mga
	video_cards_nouveau
	video_cards_nv
	video_cards_omap
	video_cards_qxl
	video_cards_r128
	video_cards_radeon
	video_cards_radeonsi
	video_cards_siliconmotion
	video_cards_tegra
	video_cards_vc4
	video_cards_vesa
	video_cards_via
	video_cards_virtualbox
	video_cards_vmware
	video_cards_nvidia
"

IUSE="${IUSE_VIDEO_CARDS} ${IUSE_INPUT_DEVICES}"

PDEPEND="
	input_devices_elographics? ( x11-drivers/xf86-input-elographics )
	input_devices_evdev?       (
								 >=x11-base/xorg-server-${PV}[udev]
								 >=x11-drivers/xf86-input-evdev-2.10.6
							   )
	input_devices_joystick?    ( >=x11-drivers/xf86-input-joystick-1.6.3 )
	input_devices_libinput?    (
								 >=x11-base/xorg-server-${PV}[udev]
								 >=x11-drivers/xf86-input-libinput-0.27.1
							   )
	input_devices_vmmouse?     ( x11-drivers/xf86-input-vmmouse )
	input_devices_void?        ( x11-drivers/xf86-input-void )
	input_devices_synaptics?   ( x11-drivers/xf86-input-synaptics )
	input_devices_wacom?       ( >=x11-drivers/xf86-input-wacom-0.36.0-r2 )

	video_cards_amdgpu?        ( >=x11-drivers/xf86-video-amdgpu-18.0.1 )
	video_cards_ast?           ( x11-drivers/xf86-video-ast )
	video_cards_dummy?         ( x11-drivers/xf86-video-dummy )
	video_cards_fbdev?         ( >=x11-drivers/xf86-video-fbdev-0.5.0 )
	video_cards_freedreno?     ( >=x11-base/xorg-server-${PV}[-minimal] )
	video_cards_geode?         ( x11-drivers/xf86-video-geode )
	video_cards_glint?         ( >=x11-drivers/xf86-video-glint-1.2.9 )
	video_cards_i915?          ( x11-drivers/xf86-video-intel )
	video_cards_i965?          ( >=x11-base/xorg-server-${PV}[-minimal] )
	video_cards_intel?         ( !video_cards_i965? ( >=x11-drivers/xf86-video-intel-2.99.917_p20180214-r1 ) )
	video_cards_mga?           ( >=x11-drivers/xf86-video-mga-1.6.5 )
	video_cards_nouveau?       ( >=x11-drivers/xf86-video-nouveau-1.0.13 )
	video_cards_nv?            ( >=x11-drivers/xf86-video-nv-2.1.21 )
	video_cards_omap?          ( >=x11-drivers/xf86-video-omap-0.4.5 )
	video_cards_qxl?           ( x11-drivers/xf86-video-qxl )
	video_cards_nvidia?        ( x11-drivers/nvidia-drivers )
	video_cards_r128?          ( >=x11-drivers/xf86-video-r128-6.10.2 )
	video_cards_radeon?        ( >=x11-drivers/xf86-video-ati-18.0.1-r1 )
	video_cards_radeonsi?      ( >=x11-drivers/xf86-video-ati-18.0.1-r1 )
	video_cards_siliconmotion? ( >=x11-drivers/xf86-video-siliconmotion-1.7.9 )
	video_cards_tegra?         ( >=x11-base/xorg-server-${PV}[-minimal] )
	video_cards_vc4?           ( >=x11-base/xorg-server-${PV}[-minimal] )
	video_cards_vesa?          ( x11-drivers/xf86-video-vesa )
	video_cards_via?           ( x11-drivers/xf86-video-openchrome )
	video_cards_virtualbox?    ( x11-drivers/xf86-video-vboxvideo )
	video_cards_vmware?        ( >=x11-drivers/xf86-video-vmware-13.3.0 )
"
