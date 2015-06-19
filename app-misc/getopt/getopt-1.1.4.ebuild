# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/getopt/getopt-1.1.4.ebuild,v 1.7 2012/04/26 17:13:54 aballier Exp $

EAPI=3

inherit toolchain-funcs eutils

DESCRIPTION="getopt(1) replacement supporting GNU-style long options"
HOMEPAGE="http://software.frodo.looijaard.name/getopt/"
SRC_URI="http://software.frodo.looijaard.name/getopt/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}/${P}-libintl.patch"
	epatch "${FILESDIR}/${P}-longrename.patch"

	# hopefully this is portable enough
	epatch "${FILESDIR}"/${P}-irix.patch
}

src_compile() {
	local nogettext="1"
	local libintl=""
	local libcgetopt=1

	if use nls; then
		nogettext=0
		has_version sys-libs/glibc || libintl="-lintl"
	fi

	[[ ${CHOST} == *-irix* ]] && libcgetopt=0
	[[ ${CHOST} == *-interix* ]] && libcgetopt=0

	emake CC="$(tc-getCC)" prefix="${EPREFIX}/usr" \
		LIBCGETOPT=${libcgetopt} \
		WITHOUT_GETTEXT=${nogettext} LIBINTL=${libintl} \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	use nls && make prefix="${EPREFIX}/usr" DESTDIR="${D}" install_po

	into /usr
	newbin getopt getopt-long

	# at least on interix, the system getopt is ... broken...
	# util-linux, which would provide the getopt binary, does not build &
	# install on interix/prefix, so, this has to provide it.
	[[ ${CHOST} == *-interix* || ${CHOST} == *-mint* ]] && \
		dosym getopt-long /usr/bin/getopt

	newman getopt.1 getopt-long.1

	dodoc "${S}/getopt-"*sh
}
