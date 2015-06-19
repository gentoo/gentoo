# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/getopt/getopt-1.1.6.ebuild,v 1.2 2015/02/17 14:49:52 haubi Exp $

EAPI=4

inherit toolchain-funcs eutils

DESCRIPTION="getopt(1) replacement supporting GNU-style long options"
HOMEPAGE="http://software.frodo.looijaard.name/getopt/"
SRC_URI="http://frodo.looijaard.name/system/files/software/getopt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.5-libintl.patch
	epatch "${FILESDIR}"/${PN}-1.1.5-setlocale.patch
	epatch "${FILESDIR}"/${PN}-1.1.6-longrename.patch

	# hopefully this is portable enough
	epatch "${FILESDIR}"/${PN}-1.1.4-irix.patch
}

src_compile() {
	local nogettext="1"
	local libintl=""
	local libcgetopt=1

	if use nls; then
		nogettext=0
		has_version sys-libs/glibc || libintl="-lintl"
	fi

	[[ ${CHOST} == *-aix* ]] && libcgetopt=0
	[[ ${CHOST} == *-irix* ]] && libcgetopt=0
	[[ ${CHOST} == *-interix* ]] && libcgetopt=0

	emake CC="$(tc-getCC)" prefix="${EPREFIX}/usr" \
		LIBCGETOPT=${libcgetopt} \
		WITHOUT_GETTEXT=${nogettext} LIBINTL=${libintl} \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	use nls && emake prefix="${EPREFIX}/usr" DESTDIR="${D}" install_po

	newbin getopt getopt-long

	# at least on interix, the system getopt is ... broken...
	# util-linux, which would provide the getopt binary, does not build &
	# install on interix/prefix, so, this has to provide it.
	[[ ${CHOST} == *-interix* || ${CHOST} == *-mint* ]] && \
		dosym getopt-long /usr/bin/getopt

	newman getopt.1 getopt-long.1

	dodoc getopt-*sh
}
