# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Xfce Desktop Environment (meta package)"
HOMEPAGE="https://www.xfce.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="minimal +svg"

RDEPEND=">=x11-themes/gtk-engines-xfce-3:0
	x11-themes/hicolor-icon-theme
	>=xfce-base/exo-0.12.5
	>=xfce-base/garcon-0.6.2
	>=xfce-base/libxfce4ui-4.13.5
	>=xfce-base/libxfce4util-4.13.3
	>=xfce-base/thunar-1.8.6
	>=xfce-base/xfce4-appfinder-4.13.3
	>=xfce-base/xfce4-panel-4.13.5
	>=xfce-base/xfce4-session-4.13.2
	>=xfce-base/xfce4-settings-4.13.6
	>=xfce-base/xfconf-4.13.7
	>=xfce-base/xfdesktop-4.13.4
	>=xfce-base/xfwm4-4.13.2
	>=xfce-extra/thunar-volman-0.9.2
	>=xfce-extra/tumbler-0.2.4
	!minimal? (
		media-fonts/dejavu
		virtual/freedesktop-icon-theme
		)
	svg? ( gnome-base/librsvg )"
