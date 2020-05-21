# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Library for Qt that implements the OAuth 1.0 authentication specification"
HOMEPAGE="https://github.com/kypeli/kQOAuth"
SRC_URI="https://github.com/kypeli/kQOAuth/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/kQOAuth-${PV}"

src_prepare() {
	default

	# prevent tests from beeing built at src_compile
	sed -i -e '/SUBDIRS/s/ tests//' ${PN}.pro || die "sed on ${PN}.pro failed"
	# respect libdir
	sed -e 's:{INSTALL_PREFIX}/lib:[QT_INSTALL_LIBS]:g'\
		-i src/src.pro || die "sed on src.pro failed"

	sed -e "s/TARGET = kqoauth/TARGET = kqoauth-qt5/g" \
		-i src/src.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
