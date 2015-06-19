# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/twolame/twolame-0.3.13-r1.ebuild,v 1.12 2014/10/11 13:08:48 maekke Exp $

EAPI=5

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
inherit autotools-multilib

DESCRIPTION="An optimised MPEG Audio Layer 2 (MP2) encoder"
HOMEPAGE="http://www.twolame.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=">=media-libs/libsndfile-1.0.25[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r6
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README TODO )

src_prepare() {
	sed -i -e '/CFLAGS/s:-O3::' configure || die

	if [[ ${CHOST} == *solaris* ]]; then
		# libsndfile doesn't like -std=c99 on Solaris
		sed -i -e '/CFLAGS/s:-std=c99::' configure || die
		# configure isn't really bourne shell (comment 0) or dash (comment 6)
		# compatible, bug #388885
		export CONFIG_SHELL=${BASH}
	fi

	autotools-multilib_src_prepare
}

src_install() {
	autotools-multilib_src_install \
		pkgdocdir="${EPREFIX}/usr/share/doc/${PF}"
}
