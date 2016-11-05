# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit eutils python-single-r1

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DESCRIPTION="Convert between document formats supported by Libreoffice"
HOMEPAGE="http://dag.wieers.com/home-made/unoconv/"
SRC_URI="https://github.com/dagwieers/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	!app-text/odt2txt
	virtual/ooo
"

src_prepare() {
	epatch "${FILESDIR}/timeout.patch"
	python_fix_shebang .
}

src_compile() { :; }

src_install() {
	emake -j1 doc-install install install-links DESTDIR="${D}" || die

	dodoc ChangeLog CHANGELOG.md README.adoc || die
}
