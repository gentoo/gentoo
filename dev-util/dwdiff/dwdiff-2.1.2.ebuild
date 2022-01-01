# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="diff-like program operating at word level instead of line level"
HOMEPAGE="https://os.ghalkes.nl/dwdiff.html"
SRC_URI="https://os.ghalkes.nl/dist/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="nls"

CDEPEND="dev-libs/icu:="

RDEPEND="
	${CDEPEND}
	sys-apps/diffutils"

DEPEND="
	${CDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(

)

src_prepare() {
	default

	sed -i \
		-e '/INSTALL/s:COPYING::' \
		Makefile.in || die
}

src_configure() {
	./configure \
		--prefix=/usr \
		$(use_with nls gettext) || die "./configure error"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake prefix="${D}/usr" docdir="${D}/usr/share/doc/${PF}" install
}
