# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xwininfo/xwininfo-1.1.3.ebuild,v 1.11 2015/03/03 10:54:03 dlan Exp $

EAPI=5

inherit xorg-2 flag-o-matic

DESCRIPTION="window information utility for X"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND=">=x11-libs/libxcb-1.6"
DEPEND="${RDEPEND}
	x11-libs/libX11
	>=x11-proto/xproto-7.0.17"

pkg_setup() {
	# interix has a _very_ old iconv in libc, however, including
	# iconv.h redefines those symbols to libiconv_*, which then
	# are unresolved, as the configure check is old and dumb.
	[[ ${CHOST} == *-interix* || ${CHOST} == *-solaris* ]] &&
		append-libs -liconv
}
