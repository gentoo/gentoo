# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN%-docs}"
MY_P="${MY_PN}-${PV}"

SRC_URI="https://github.com/clsync/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Clsync and libclsync API documentation"
HOMEPAGE="http://ut.mephi.ru/oss/clsync https://github.com/clsync/clsync"
LICENSE="GPL-3+"
SLOT="0"
IUSE="api +examples"

BDEPEND="api? ( app-doc/doxygen[dot] )"

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
		dodoc -r doc/doxygen/html doc/devel/*
	fi
	if use examples; then
		dodoc -r examples
	fi
}
