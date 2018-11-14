# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Simple, capable content management system for producing static content"
HOMEPAGE="http://blaze.blackened.cz/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz
	doc? ( https://${PN}.googlecode.com/files/${PN}-doc-${PV}.tar.gz ) "

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e '/-m 644 COPYING/d' \
		-e '/-m 644 INSTALL/d' \
		-i Makefile || die
}

src_install() {
	emake prefix="${D}/usr" config="${D}/etc" install

	use doc && dohtml -r "${WORKDIR}"/${PN}-doc-${PV}/*
}
