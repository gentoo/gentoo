# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit python-single-r1

DESCRIPTION="Utility that scans through the system and generates a menu of installed programs"
HOMEPAGE="http://menumaker.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"

IUSE="doc"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? ( sys-apps/texinfo )"

src_configure() {
	PYTHON_BIN="${PYTHON}" econf
}

src_compile() {
	default

	if use doc; then
		cd doc || die
		emake html || die "Generation of documentation failed"
	fi
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"

	python_optimize "${D}"/usr/share/menumaker

	if use doc; then
		docinto html
		dodoc doc/mmaker.html/*
	fi
}
