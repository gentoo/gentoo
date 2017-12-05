# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils qmake-utils

DESCRIPTION="OAuth2 plugin for Signon daemon"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="https://dev.gentoo.org/~kensington/distfiles/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	net-libs/signond
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

src_prepare() {
	if use !test; then
		sed -i -e '/^SUBDIRS/s/tests//' signon-oauth2.pro || die "couldn't disable tests"
	else
		sed -i -e '/^INSTALLS.*/,+1d' tests/tests.pro || die "couldn't remove tests from install target"
	fi

	epatch "${FILESDIR}/${P}-unused-dependency.patch"
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
