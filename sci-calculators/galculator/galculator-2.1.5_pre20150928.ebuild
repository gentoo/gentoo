# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="GTK+ based algebraic and RPN calculator"
HOMEPAGE="https://github.com/galculator/galculator"
COMMIT="ccf6f06602a5cf9d9fc95d767b545b03af6a7f71"
SRC_URI="https://github.com/galculator/galculator/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	app-alternatives/lex
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.4-fno-common.patch
	"${FILESDIR}"/${PN}-2.1.4-c23.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc doc/shortcuts

	mv "${ED}"/usr/share/{appdata,metainfo} || die
}
