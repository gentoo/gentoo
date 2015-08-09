# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2 vcs-snapshot

DESCRIPTION="Library for Qt that implements the OAuth 1.0 authentication specification"
HOMEPAGE="https://github.com/kypeli/kQOAuth"
SRC_URI="https://github.com/kypeli/kQOAuth/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}"

src_prepare() {
	# prevent tests from beeing built at src_compile
	sed -i -e '/SUBDIRS/s/ tests//' ${PN}.pro || die "sed on ${PN}.pro failed"
	# respect libdir
	sed -e 's:{INSTALL_PREFIX}/lib:[QT_INSTALL_LIBS]:g' -i src/src.pro || die "sed on src.pro failed"

	qt4-r2_src_prepare
}
