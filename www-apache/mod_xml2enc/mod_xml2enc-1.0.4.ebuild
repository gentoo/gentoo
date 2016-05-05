# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit apache-module

DESCRIPTION="An Apache2 module to provide libxml2 encoding"
HOMEPAGE="http://apache.webthing.com/mod_xml2enc/"
SRC_URI="http://apache.webthing.com/svn/apache/filters/${PN}.h -> ${P}.h
	http://apache.webthing.com/svn/apache/filters/${PN}.c -> ${P}.c"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libxml2"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="26_${PN}"
APACHE2_MOD_DEFINE="XML2ENC"

need_apache2

S="${WORKDIR}"/${PN}

src_unpack() {
	mkdir "${WORKDIR}"/${PN} || die
	cp "${DISTDIR}/${P}.h" "${WORKDIR}/${PN}/${PN}.h" || die
	cp "${DISTDIR}/${P}.c" "${WORKDIR}/${PN}/${PN}.c" || die
}

src_compile() {
	APXS2_ARGS="$(xml2-config --cflags) -c ${PN}.c"
	apache-module_src_compile
}
