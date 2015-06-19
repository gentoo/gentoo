# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/cpik/cpik-0.7.2_p4.ebuild,v 1.2 2014/03/10 14:27:58 kensington Exp $

EAPI=5

inherit qt4-r2

MY_PV="${PV/_p/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="C compiler for PIC18 devices"
HOMEPAGE="http://pikdev.free.fr/"
SRC_URI="http://pikdev.free.fr/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS="${MY_PV/-*/}/doc/*.pdf"
HTML_DOCS="${MY_PV/-*/}/doc/html/."

src_prepare() {
	# does not install docs in wrong path
	sed -i -e '/INSTALLS += docs/d' "${PN}"*.pro || die 'sed failed.'

	qt4-r2_src_prepare
}

src_install() {
	qt4-r2_src_install

	dosym "${PN}-${MY_PV/-*/}" "/usr/bin/${PN}"
}
