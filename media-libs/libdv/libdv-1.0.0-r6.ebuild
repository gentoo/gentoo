# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Software codec for dv-format video (camcorders etc)"
HOMEPAGE="http://libdv.sourceforge.net/"
SRC_URI="
	https://downloads.sourceforge.net/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-1.0.0-patches.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="dev-libs/popt:="
DEPEND="
	${RDEPEND}
	media-libs/libsdl
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${WORKDIR}"/${PN}-1.0.0-patches/${PN}-0.99-2.6.patch
	"${WORKDIR}"/${PN}-1.0.0-patches/${PN}-1.0.0-pic.patch
	"${WORKDIR}"/${PN}-1.0.0-patches/${PN}-1.0.0-solaris.patch
	"${WORKDIR}"/${PN}-1.0.0-patches/${PN}-1.0.0-darwin.patch
	"${WORKDIR}"/${PN}-1.0.0-patches/${PN}-1.0.0-c99.patch
)

src_prepare() {
	default
	eautoreconf

	# bug #877709
	append-cflags -fno-strict-aliasing $(test-flags-CC -fno-aggressive-loop-optimizations)
	append-cppflags "-I${S}"
}

multilib_src_configure() {
	# bug #622662, bug #910291
	tc-ld-force-bfd

	local myeconfargs=(
		--without-debug
		--disable-gtk
		$([[ ${CHOST} == *86*-darwin* ]] && echo "--disable-asm")
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	if ! multilib_is_native_abi ; then
		sed -i \
			-e 's/ encodedv//' \
			Makefile || die
	fi
}

multilib_src_install_all() {
	einstalldocs

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
