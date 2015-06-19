# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/mkfontscale/mkfontscale-1.1.2.ebuild,v 1.11 2015/05/24 03:02:53 mattst88 Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="create an index of scalable font files for X"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libfontenc
	media-libs/freetype:2
	sys-libs/zlib
	app-arch/bzip2"
DEPEND="${RDEPEND}
	x11-proto/xproto
	app-arch/gzip"

XORG_CONFIGURE_OPTIONS=(
	--with-bzip2
)
