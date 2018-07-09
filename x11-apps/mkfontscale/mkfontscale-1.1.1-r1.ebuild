# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="create an index of scalable font files for X"
HOMEPAGE="https://www.x.org/wiki/"
SRC_URI="mirror://xorg/app/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	app-arch/bzip2
	media-libs/freetype:2
	sys-libs/zlib
	x11-libs/libfontenc
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	x11-misc/util-macros
"

src_configure() {
	econf --with-bzip2
}
