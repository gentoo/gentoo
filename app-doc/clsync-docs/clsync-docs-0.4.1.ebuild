# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/clsync-docs/clsync-docs-0.4.1.ebuild,v 1.1 2015/05/25 00:10:53 bircoph Exp $

EAPI=5

MY_PN="${PN%-docs}"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xaionaro/${MY_PN}.git"
else
	SRC_URI="https://github.com/xaionaro/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Clsync and libclsync API documentation"
HOMEPAGE="http://ut.mephi.ru/oss/clsync https://github.com/xaionaro/clsync"
LICENSE="GPL-3+"
SLOT="0"
IUSE="api +examples"

DEPEND="
	app-doc/doxygen
	virtual/pkgconfig
"

src_configure() {
	: # doxygen doesn't depend on configuration
}

src_compile() {
	if use api; then
		doxygen .doxygen || die "doxygen failed"
	fi
}

src_install() {
	dodoc CONTRIB DEVELOPING NOTES PROTOCOL README.md SHORTHANDS TODO
	if use api; then
		dohtml -r doc/doxygen/html/*
		dodoc -r doc/devel/*
	fi
	if use examples; then
		docinto examples
		dodoc -r examples/{production,clsync*}
	fi
}
