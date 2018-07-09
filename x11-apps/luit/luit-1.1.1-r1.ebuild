# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Locale and ISO 2022 support for Unicode terminals"
HOMEPAGE="https://www.x.org/wiki/ https://cgit.freedesktop.org/"
SRC_URI="mirror://xorg/app/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libfontenc
"
DEPEND="
	${RDEPEND}
	x11-misc/util-macros
"

PATCHES=(
	# posix_openpt() call needs POSIX 2004, bug #415949
	"${FILESDIR}"/${PN}-1.1.1-xopen_source_600.patch
)

src_prepare() {
	default
	eautoreconf
}
