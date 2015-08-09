# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
