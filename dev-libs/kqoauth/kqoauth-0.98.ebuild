# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/kqoauth/kqoauth-0.98.ebuild,v 1.3 2014/04/03 07:55:27 zlogene Exp $

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

	qt4-r2_src_prepare
}
