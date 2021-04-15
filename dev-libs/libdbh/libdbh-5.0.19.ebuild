# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools

MY_P=${PN}2-${PV}

DESCRIPTION="a small library to create and manage 64-bit disk based hash tables"
HOMEPAGE="https://www.gnu.org/software/libdbh/"
SRC_URI="mirror://sourceforge/dbh/dbh/${PV}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	sed -i -e "s:-O2:${CFLAGS}:" m4/rfm-conditionals.m4 || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
