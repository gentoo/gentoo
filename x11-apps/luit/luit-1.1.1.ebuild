# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
XORG_EAUTORECONF=yes

inherit xorg-2

DESCRIPTION="Locale and ISO 2022 support for Unicode terminals"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
RDEPEND="sys-libs/zlib
	x11-libs/libX11
	x11-libs/libfontenc"
DEPEND="${RDEPEND}"

src_prepare() {
	# posix_openpt() call needs POSIX 2004, bug #415949
	sed -i 's/-D_XOPEN_SOURCE=500/-D_XOPEN_SOURCE=600/' configure.ac || die
	xorg-2_src_prepare
}
