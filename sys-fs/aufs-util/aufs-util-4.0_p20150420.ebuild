# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/aufs-util/aufs-util-4.0_p20150420.ebuild,v 1.2 2015/04/20 08:25:13 jlec Exp $

EAPI=5

inherit eutils flag-o-matic linux-info multilib toolchain-funcs

DESCRIPTION="Utilities are always necessary for aufs"
HOMEPAGE="http://aufs.sourceforge.net/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"
# git archive -v --prefix=${P}/ --remote=git://git.code.sf.net/p/aufs/aufs-util aufs4.0 -o ${P}.tar
# xz -ve9 *.tar

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	!sys-fs/aufs2
	!<sys-fs/aufs3-3_p20130318"
DEPEND="${RDEPEND}
	~sys-fs/aufs-headers-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-version.patch
	sed \
		-e "/LDFLAGS += -static -s/d" \
		-e "/CFLAGS/s:-O::g" \
		-i Makefile || die

	sed \
		-e '/LDFLAGS/s: -s::g' \
		-e "s:m 644 -s:m 644:g" \
		-e "s:/usr/lib:/usr/$(get_libdir):g" \
		-i libau/Makefile || die

	sed \
		-e '/LDFLAGS/s: -s::g' \
		-e '/LDLIBS/s:-lrt::g' \
		-e '/LDLIBS/s:$: -lrt:g' \
		-i fhsm/Makefile || die

	tc-export CC AR
	export HOSTCC=$(tc-getCC)
}
