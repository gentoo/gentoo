# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Xfce Desktop Environment (meta package)"
HOMEPAGE="https://www.xfce.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv x86"
IUSE="minimal pulseaudio +svg upower"

RDEPEND="
	x11-themes/hicolor-icon-theme
	>=xfce-base/exo-4.16
	>=xfce-base/garcon-0.8
	>=xfce-base/libxfce4ui-4.16
	>=xfce-base/libxfce4util-4.16
	>=xfce-base/thunar-4.16
	>=xfce-base/thunar-volman-4.16
	>=xfce-base/xfce4-appfinder-4.16
	>=xfce-base/xfce4-panel-4.16
	>=xfce-base/xfce4-session-4.16
	>=xfce-base/xfce4-settings-4.16
	x11-terms/xfce4-terminal
	>=xfce-base/xfconf-4.16
	>=xfce-base/xfdesktop-4.16
	>=xfce-base/xfwm4-4.16
	>=xfce-extra/tumbler-4.16
	!minimal? (
		media-fonts/dejavu
		virtual/freedesktop-icon-theme
		)
	pulseaudio? ( xfce-extra/xfce4-pulseaudio-plugin )
	svg? ( gnome-base/librsvg )
	upower? ( >=xfce-extra/xfce4-power-manager-4.16 )
"
