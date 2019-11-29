# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Xfce Desktop Environment (meta package)"
HOMEPAGE="https://www.xfce.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="minimal +svg upower"

RDEPEND="x11-themes/hicolor-icon-theme
	>=xfce-base/exo-0.12.8
	>=xfce-base/garcon-0.6.4
	>=xfce-base/libxfce4ui-4.14.1
	>=xfce-base/libxfce4util-4.14.0
	>=xfce-base/thunar-1.8.9
	>=xfce-base/xfce4-appfinder-4.14.0
	>=xfce-base/xfce4-panel-4.14.0
	>=xfce-base/xfce4-session-4.14.0
	>=xfce-base/xfce4-settings-4.14.0
	x11-terms/xfce4-terminal
	>=xfce-base/xfconf-4.14.1
	>=xfce-base/xfdesktop-4.14.1
	>=xfce-base/xfwm4-4.14.0
	>=xfce-extra/thunar-volman-0.9.5
	>=xfce-extra/tumbler-0.2.7
	!minimal? (
		media-fonts/dejavu
		virtual/freedesktop-icon-theme
		)
	svg? ( gnome-base/librsvg )
	upower? ( >=xfce-extra/xfce4-power-manager-1.6.5 )"
