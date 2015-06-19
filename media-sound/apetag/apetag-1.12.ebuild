# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/apetag/apetag-1.12.ebuild,v 1.4 2010/08/23 17:45:05 ssuominen Exp $

EAPI=3

PYTHON_DEPEND="2"

inherit python toolchain-funcs

DESCRIPTION="Command-line ape 2.0 tagger"
HOMEPAGE="http://muth.org/Robert/Apetag/"
SRC_URI="http://muth.org/Robert/Apetag/${PN}.${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/Apetag

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i \
		-e 's:CXXDEBUG:LDFLAGS:' \
		Makefile || die
	python_convert_shebangs -r 2 .
}

src_compile() {
	tc-export CXX
	emake \
		CXXFLAGS="${CXXFLAGS} -Wall -pedantic" \
		LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin ${PN} || die

	local sitedir="$(python_get_sitedir)"/${PN}
	exeinto ${sitedir}
	doexe *.py || die

	local x
	for x in {rmid3tag,tagdir}.py; do
		ln -s "${sitedir}"/${x} "${D}"/usr/bin/${x} || die
	done

	dodoc 00readme
}

pkg_postinst() {
	python_mod_optimize apetag
}

pkg_postrm() {
	python_mod_cleanup apetag
}
