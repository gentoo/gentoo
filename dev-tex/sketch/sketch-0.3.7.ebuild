# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="Produces drawings of two- or three-dimensional solid objects and scenes for TeX"
HOMEPAGE="https://www.frontiernet.net/~eugene.ressler/"
SRC_URI="https://www.frontiernet.net/~eugene.ressler/${P}.tgz"

KEYWORDS="~amd64 ~ppc64 ~x86"

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc examples"

DEPEND="dev-lang/perl"
RDEPEND=""

src_prepare() {
	sed -i -e "s:\$(CC):\$(CC) \$(LDFLAGS):" makefile || die "Fixing Makefile failed"
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin sketch
	edos2unix Doc/sketch.info
	doinfo Doc/sketch.info
	dodoc -r updates.htm

	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins Doc/sketch.pdf
		dodoc -r Doc/sketch/*
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins Data/*
	fi
}
