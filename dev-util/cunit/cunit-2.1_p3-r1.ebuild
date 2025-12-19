# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal toolchain-funcs

MY_PN="CUnit"
MY_PV="${PV/_p*}-3"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="C Unit Test Framework"
HOMEPAGE="https://cunit.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/cunit/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="ncurses static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1_p3-ncurses-format-security.patch
	"${FILESDIR}"/${PN}-2.1_p3-ncurses-opaque.patch
)

src_prepare() {
	default

	sed -e "/^docdir/d" -i doc/Makefile.am || die
	sed -e '/^dochdrdir/{s:$(prefix)/doc/@PACKAGE@:$(docdir):}' \
		-i doc/headers/Makefile.am || die
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.in || die

	mv configure.{in,ac} || die
	eautoreconf

	append-cppflags -D_BSD_SOURCE

	# unable to find headers otherwise
	multilib_copy_sources
}

multilib_src_configure() {
	local LIBS=${LIBS}
	append-libs $($(tc-getPKG_CONFIG) --libs ncurses)

	econf \
		$(use_enable static-libs static) \
		--disable-debug \
		$(use_enable ncurses curses) \
		$(use_enable test)
}

multilib_src_test() {
	default

	cd CUnit/Sources/Test || die
	./test_cunit || die
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -type f -delete || die
}
