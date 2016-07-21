# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DEB_PATCH_VER=${PV#*_p}
MY_VER=${PV%_p*}

DESCRIPTION="Move/copy/append/link multiple files according to a set of wildcard patterns"
HOMEPAGE="http://packages.debian.org/unstable/utils/mmv"
SRC_URI="
	mirror://debian/pool/main/m/mmv/${PN}_${MY_VER}.orig.tar.gz
	mirror://debian/pool/main/m/mmv/${PN}_${MY_VER}-${DEB_PATCH_VER}.debian.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

S="${WORKDIR}"/${PN}-${MY_VER}.orig

src_prepare() {
	epatch "${WORKDIR}"/debian/patches/*.diff
}

src_compile() {
	# i wonder how this works on other platforms if CFLAGS from makefile are
	# overridden, see bug #218082
	[[ ${CHOST} == *-interix* ]] && append-flags -DIS_SYSV -DHAS_RENAME -DHAS_DIRENT
	[[ ${CHOST} == *-interix* ]] || append-lfs-flags

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin mmv
	dosym mmv /usr/bin/mcp
	dosym mmv /usr/bin/mln
	dosym mmv /usr/bin/mad

	doman mmv.1
	newman mmv.1 mcp.1
	newman mmv.1 mln.1
	newman mmv.1 mad.1

	dodoc ANNOUNCE "${WORKDIR}"/debian/{changelog,control}
}
