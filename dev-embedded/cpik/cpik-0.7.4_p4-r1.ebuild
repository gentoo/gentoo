# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_p/-}"
MY_P="${PN}-${MY_PV}"
inherit qmake-utils

DESCRIPTION="C compiler for PIC18 devices"
HOMEPAGE="http://pikdev.free.fr/"
SRC_URI="http://pikdev.free.fr/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-qt/qtbase:6"

DOCS=( ${MY_PV/-*/}/doc/cpik-{0.5.2-tutorial,0.7.4-4-doc}.pdf )
HTML_DOCS=( ${MY_PV/-*/}/doc/html/. )

PATCHES=( "${FILESDIR}/${P}-gcc6.patch" )

src_prepare() {
	default

	# installs docs in wrong path
	sed -e '/INSTALLS += docs/d' -i "${PN}"*.pro || die
}

src_configure() {
	eqmake6
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
	dosym "${PN}-${MY_PV/-*/}" "/usr/bin/${PN}"
}
