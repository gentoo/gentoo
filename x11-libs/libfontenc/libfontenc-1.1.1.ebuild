# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libfontenc/libfontenc-1.1.1.ebuild,v 1.10 2013/02/21 19:29:03 zmedico Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="X.Org fontenc library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND="sys-libs/zlib
	x11-proto/xproto"
DEPEND="${RDEPEND}"

XORG_CONFIGURE_OPTIONS=(
	--with-encodingsdir="${EPREFIX}/usr/share/fonts/encodings"
)
