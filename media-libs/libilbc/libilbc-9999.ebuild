# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libilbc/libilbc-9999.ebuild,v 1.2 2012/11/22 01:17:41 lu_zero Exp $

EAPI=4

if [[ ${PV} == 9999 ]] ; then
	SCM="autotools git-2"
	EGIT_REPO_URI="git://github.com/lu-zero/libilbc.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://dev.gentoo.org/~lu_zero/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

inherit eutils multilib ${SCM}

DESCRIPTION="Packaged version of iLBC codec from the WebRTC project"
HOMEPAGE="https://github.com/dekkers/libilbc"

LICENSE="BSD"
SLOT="0"
IUSE=""

src_prepare() {
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${D}"usr/$(get_libdir) -name '*.la' -delete
}
