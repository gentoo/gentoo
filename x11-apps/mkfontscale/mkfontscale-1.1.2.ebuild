# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="create an index of scalable font files for X"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libfontenc
	media-libs/freetype:2
	sys-libs/zlib
	app-arch/bzip2"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/util-macros
	app-arch/gzip"

XORG_CONFIGURE_OPTIONS=(
	--with-bzip2
)
