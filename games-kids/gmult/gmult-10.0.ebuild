# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala xdg

DESCRIPTION="Multiplication Puzzle emulates the multiplication game found in Emacs"
HOMEPAGE="https://launchpad.net/gmult/"
SRC_URI="https://launchpad.net/gmult/trunk/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3+ CC-BY-SA-4.0 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test" # only used for unnecessary .desktop/.po validation

RDEPEND="
	dev-libs/glib:2
	gui-libs/gtk:4[introspection]
	gui-libs/libadwaita:1[vala]
	virtual/libintl
	x11-libs/cairo
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-10.0-no-icon-cache.patch
)

DOCS=( NEWS.md README.md )

src_configure() {
	vala_setup
	meson_src_configure
}
