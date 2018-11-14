# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

if [[ ${PV} == 9999 ]] ; then
	SCM="autotools git-2"
	EGIT_REPO_URI="https://github.com/lu-zero/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://dev.gentoo.org/~lu_zero/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
fi

inherit eutils multilib ${SCM}

DESCRIPTION="Packaged version of iLBC codec from the WebRTC project"
HOMEPAGE="https://github.com/lu-zero/libilbc https://github.com/TimothyGu/libilbc"

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
