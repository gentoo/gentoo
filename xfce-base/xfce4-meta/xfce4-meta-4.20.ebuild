# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Xfce Desktop Environment (meta package)"
HOMEPAGE="https://www.xfce.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="
	archive calendar cdr editor image media minimal mpd pulseaudio
	remote-fs search +svg upower
"

RDEPEND="
	x11-terms/xfce4-terminal
	x11-themes/hicolor-icon-theme
	>=xfce-base/exo-4.20.0
	>=xfce-base/garcon-4.20.0
	>=xfce-base/libxfce4ui-4.20.0
	>=xfce-base/libxfce4util-4.20.0
	>=xfce-base/libxfce4windowing-4.20.0
	>=xfce-base/thunar-4.20.0
	>=xfce-base/thunar-volman-4.20.0
	>=xfce-base/tumbler-4.20.0
	>=xfce-base/xfce4-appfinder-4.20.0
	>=xfce-base/xfce4-panel-4.20.0
	>=xfce-base/xfce4-session-4.20.0
	>=xfce-base/xfce4-settings-4.20.0
	>=xfce-base/xfconf-4.20.0
	>=xfce-base/xfdesktop-4.20.0
	>=xfce-base/xfwm4-4.20.0
	!minimal? (
		media-fonts/dejavu
		virtual/freedesktop-icon-theme
	)
	archive? ( app-arch/xarchiver )
	calendar? ( app-office/orage )
	cdr? ( app-cdr/xfburn )
	editor? ( app-editors/mousepad )
	image? ( media-gfx/ristretto )
	media? ( media-video/parole )
	mpd? ( media-sound/xfmpc )
	pulseaudio? ( xfce-extra/xfce4-pulseaudio-plugin )
	remote-fs? ( x11-misc/gigolo )
	search? ( dev-util/catfish )
	svg? ( gnome-base/librsvg )
	upower? ( >=xfce-base/xfce4-power-manager-4.20.0 )
"
