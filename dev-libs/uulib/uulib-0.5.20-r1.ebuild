# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=uudeview-${PV}

DESCRIPTION="Library that supports Base64 (MIME), uuencode, xxencode and binhex coding"
HOMEPAGE="http://www.fpx.de/fp/Software/UUDeview/"
SRC_URI="http://www.fpx.de/fp/Software/UUDeview/download/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

BDEPEND="sys-devel/libtool"

PATCHES=(
	"${FILESDIR}"/${P}-shared.patch
)

src_prepare() {
	default

	sed -i 's:\<ar\>:$(AR):' Makefile.in || die
	# Fix Darwin and other platforms with a non-GNU default libtool
	sed -i 's/libtool/$(LIBTOOL)/' Makefile.in || die
}

src_configure() {
	tc-export AR CC RANLIB
	econf
}

src_compile() {
	if use prefix ; then
		LIBTOOL=glibtool
	else
		LIBTOOL=libtool
	fi

	LIBTOOL="${LIBTOOL}" emake
}
