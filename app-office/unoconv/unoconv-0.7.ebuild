# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/unoconv/unoconv-0.7.ebuild,v 1.1 2015/07/12 09:17:15 graaff Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit eutils python-single-r1

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DESCRIPTION="Convert between document formats supported by Libreoffice"
HOMEPAGE="http://dag.wieers.com/home-made/unoconv/"
SRC_URI="https://github.com/dagwieers/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

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
