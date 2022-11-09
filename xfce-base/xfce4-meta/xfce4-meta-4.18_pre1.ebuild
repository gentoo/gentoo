# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Xfce Desktop Environment (meta package)"
HOMEPAGE="https://www.xfce.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="minimal pulseaudio +svg upower"

RDEPEND="
	x11-themes/hicolor-icon-theme
	>=xfce-base/exo-4.17.3
	>=xfce-base/garcon-4.17.2
	>=xfce-base/libxfce4ui-4.17.8
	>=xfce-base/libxfce4util-4.17.3
	>=xfce-base/thunar-4.17.11
	>=xfce-base/thunar-volman-4.17.0
	>=xfce-base/tumbler-4.17.3
	>=xfce-base/xfce4-appfinder-4.17.1
	>=xfce-base/xfce4-panel-4.17.4
	>=xfce-base/xfce4-session-4.17.1
	>=xfce-base/xfce4-settings-4.17.0
	x11-terms/xfce4-terminal
	>=xfce-base/xfconf-4.17.0
	>=xfce-base/xfdesktop-4.17.1
	>=xfce-base/xfwm4-4.17.1
	!minimal? (
		media-fonts/dejavu
		virtual/freedesktop-icon-theme
	)
	pulseaudio? ( xfce-extra/xfce4-pulseaudio-plugin )
	svg? ( gnome-base/librsvg )
	upower? ( >=xfce-base/xfce4-power-manager-4.17.0 )
"
