# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="Network simulation tool"
HOMEPAGE="http://www.csse.uwa.edu.au/cnet3/"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	>=dev-lang/tk-8.5
	dev-libs/elfutils
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.3.1-gentoo.patch \
		"${FILESDIR}"/${PN}-3.3.1-tcl.patch

	# Set libdir properly
	sed -i -e "/CNETPATH/s:local/lib:$(get_libdir):" src/preferences.h || die
	sed -i -e "/^LIBDIR/s:lib:$(get_libdir):" Makefile || die

	epatch_user
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ANNOUNCE
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${P}/examples
	fi
}
