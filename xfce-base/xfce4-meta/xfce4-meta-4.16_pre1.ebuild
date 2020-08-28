# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Xfce Desktop Environment (meta package)"
HOMEPAGE="https://www.xfce.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="minimal +svg upower"

RDEPEND="x11-themes/hicolor-icon-theme
	>=xfce-base/exo-4.15.2
	>=xfce-base/garcon-0.7.1
	>=xfce-base/libxfce4ui-4.15.3
	>=xfce-base/libxfce4util-4.15.3
	>=xfce-base/thunar-4.15.2
	>=xfce-base/xfce4-appfinder-4.15.1
	>=xfce-base/xfce4-panel-4.15.4
	>=xfce-base/xfce4-session-4.15.0
	>=xfce-base/xfce4-settings-4.15.2
	x11-terms/xfce4-terminal
	>=xfce-base/xfconf-4.15.0
	>=xfce-base/xfdesktop-4.15.0
	>=xfce-base/xfwm4-4.15.1
	>=xfce-extra/thunar-volman-4.15.0
	>=xfce-extra/tumbler-0.3.0
	!minimal? (
		media-fonts/dejavu
		virtual/freedesktop-icon-theme
		)
	svg? ( gnome-base/librsvg )
	upower? ( >=xfce-extra/xfce4-power-manager-1.7.0 )"
