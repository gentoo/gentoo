# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/mkfontscale/mkfontscale-1.1.1.ebuild,v 1.11 2014/01/18 12:21:01 vapier Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="create an index of scalable font files for X"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libfontenc
	media-libs/freetype:2"
DEPEND="${RDEPEND}
	x11-proto/xproto
	app-arch/gzip
	app-arch/bzip2"

XORG_CONFIGURE_OPTIONS=(
	--with-bzip2
)
