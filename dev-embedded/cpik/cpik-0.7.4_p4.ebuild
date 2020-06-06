# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

MY_PV="${PV/_p/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="C compiler for PIC18 devices"
HOMEPAGE="http://pikdev.free.fr/"
SRC_URI="http://pikdev.free.fr/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:5"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS=( ${MY_PV/-*/}/doc/cpik-{0.5.2-tutorial,0.7.4-4-doc}.pdf )
HTML_DOCS=( ${MY_PV/-*/}/doc/html/. )

PATCHES=( "${FILESDIR}/${P}-gcc6.patch" )

src_prepare() {
	default

	# does not install docs in wrong path
	sed -e '/INSTALLS += docs/d' \
		-i "${PN}"*.pro || die 'sed failed.'
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
	dosym "${PN}-${MY_PV/-*/}" "/usr/bin/${PN}"
}
