# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/kekekeks/skypetab-ng.git"
	UNPACKER_ECLASS="git-2"
	LIVE_EBUILD=yes
else
	UNPACKER_ECLASS="vcs-snapshot"
fi

inherit eutils qt4-r2 multilib ${UNPACKER_ECLASS}

if [[ -z ${LIVE_EBUILD} ]]; then
	KEYWORDS="-* ~x86 ~amd64"
	SRC_URI="https://github.com/kekekeks/${PN}/tarball/v${PV} -> ${P}.tar.gz"
fi

DESCRIPTION="An LD_PRELOAD wrapper that adds tabs to Skype for Linux"
HOMEPAGE="https://github.com/kekekeks/skypetab-ng"
LICENSE="LGPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtcore:4[abi_x86_32(-)]
	dev-qt/qtgui:4[abi_x86_32(-)]
"
RDEPEND="${DEPEND}
	|| ( >=net-im/skype-4.1 <net-im/skype-4.1[-qt-static] )
"

pkg_setup() {
	use amd64 && multilib_toolchain_setup x86
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.5.2_p20150201-isdigit.patch
}
