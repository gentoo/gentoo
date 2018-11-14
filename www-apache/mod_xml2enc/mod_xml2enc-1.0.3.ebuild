# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit apache-module

DESCRIPTION="An Apache2 module to provide libxml2 encoding"
HOMEPAGE="http://apache.webthing.com/mod_xml2enc/"
SRC_URI="http://apache.webthing.com/svn/apache/filters/mod_xml2enc.h
	http://apache.webthing.com/svn/apache/filters/mod_xml2enc.c"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/bzip2
	dev-libs/libxml2"
RDEPEND="${DEPEND}"

#APACHE2_MOD_CONF="27_${PN}"
#APACHE2_MOD_DEFINE="XML2ENC"

need_apache2

S="${WORKDIR}"/${PN}

src_unpack() {
	mkdir "${WORKDIR}"/${PN}
	cp "${DISTDIR}/mod_xml2enc.h" "${WORKDIR}"/${PN}
	cp "${DISTDIR}/mod_xml2enc.c" "${WORKDIR}"/${PN}
}

src_compile() {
	APXS2_ARGS="$(xml2-config --cflags) -c ${PN}.c"
	apache-module_src_compile
}
