# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson vala xdg

DESCRIPTION="Multiplication Puzzle emulates the multiplication game found in Emacs"
HOMEPAGE="https://launchpad.net/gmult"
SRC_URI="https://launchpad.net/gmult/trunk/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	virtual/libintl
	x11-libs/cairo
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	sys-devel/gettext"

src_prepare() {
	default
	vala_src_prepare
}
