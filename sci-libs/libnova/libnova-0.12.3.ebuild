# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils autotools flag-o-matic

DESCRIPTION="Celestial Mechanics and Astronomical Calculation Library"
HOMEPAGE="http://libnova.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="doc examples"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.12.1-configure.patch
	# 0.12.3 does not pass test with > -02
	replace-flags -O? -O1
	eautoreconf
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		cd doc
		emake doc || die "emake in doc failed"
	fi
}

src_test() {
	emake check || die "emake check failed"
	"${S}"/lntest/lntest || die "lntest failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README || die
	if use doc; then
		dohtml doc/html/* || die "dohtml failed"
	fi
	if use examples; then
		make clean
		rm -f examples/Makefile*
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}
