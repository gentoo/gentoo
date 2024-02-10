# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edo flag-o-matic

MY_P="${PN}${PV}"
DESCRIPTION="tool for automating interactive applications"
HOMEPAGE="https://core.tcl-lang.org/expect/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE="debug doc test threads"
RESTRICT="!test? ( test )"

DEPEND=">=dev-lang/tcl-8.2:=[threads?]"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-util/dejagnu )"

PATCHES=( "${FILESDIR}"/${P}-examples.patch )

src_prepare() {
	default
	sed -i "s:/usr/local/bin:${EPREFIX}/usr/bin:" expect.man || die

	eapply "${FILESDIR}"/${PN}-5.45-gfbsd.patch
	eapply "${FILESDIR}"/${PN}-5.44.1.15-ldflags.patch
	eapply "${FILESDIR}"/${PN}-5.45-headers.patch #337943
	eapply "${FILESDIR}"/${PN}-5.45-format-security.patch
	eapply "${FILESDIR}"/${PN}-5.45.4-configure-in.patch
	eapply "${FILESDIR}"/${PN}-5.45.4-configure-clang16.patch
	eapply "${FILESDIR}"/${PN}-5.45-warnings.patch

	sed -i 's:ifdef HAVE_SYS_WAIT_H:ifndef NO_SYS_WAIT_H:' *.c || die

	# fix install_name on darwin
	[[ ${CHOST} == *-darwin* ]] && \
		eapply "${FILESDIR}"/${P}-darwin-install_name.patch

	mv configure.{in,ac} || die

	eautoconf
}

src_configure() {
	# bug #881687
	append-flags -std=gnu89

	# the 64bit flag is useless ... it only adds 64bit compiler flags
	# (like -m64) which the target toolchain should already handle
	econf \
		--cache-file="${S}"/config.cache \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)" \
		--disable-64bit \
		--enable-shared \
		$(use_enable threads) \
		$(use_enable debug symbols mem)
}

expect_make_var() {
	touch pkgIndex.tcl-hand || die
	printf 'all:;echo $('$1')\ninclude Makefile' | emake --no-print-directory -s -f -
	rm -f pkgIndex.tcl-hand || die
}

src_install() {
	default

	if use doc ; then
		docinto examples

		edo dodoc \
			example/README \
			$(printf 'example/%s ' $(expect_make_var _SCRIPTS)) \
			$(printf 'example/%s.man ' $(expect_make_var _SCRIPTS_MANPAGES))
	fi
}
