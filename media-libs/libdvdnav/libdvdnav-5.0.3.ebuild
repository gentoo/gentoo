# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvdnav/libdvdnav-5.0.3.ebuild,v 1.7 2015/07/18 06:28:22 jer Exp $

EAPI=5
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
inherit autotools-multilib

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="http://dvdnav.mplayerhq.hu/"
if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.videolan.org/libdvdnav.git"
	KEYWORDS="alpha hppa ppc64"
else
	SRC_URI="http://downloads.videolan.org/pub/videolan/libdvdnav/${PV}/${P}.tar.bz2"
	KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ~ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="static-libs"

RDEPEND=">=media-libs/libdvdread-5.0.2[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r4
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig" # To get pkg.m4 for eautoreconf #414391

DOCS=( AUTHORS ChangeLog doc/dvd_structures doc/library_layout README TODO )
