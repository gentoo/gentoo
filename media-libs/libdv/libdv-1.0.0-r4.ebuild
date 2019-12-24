# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Software codec for dv-format video (camcorders etc)"
HOMEPAGE="http://libdv.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${PN}-1.0.0-pic.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND="dev-libs/popt:="
DEPEND="
	${RDEPEND}
	media-libs/libsdl"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.99-2.6.patch
	"${WORKDIR}"/${PN}-1.0.0-pic.patch
	"${FILESDIR}"/${PN}-1.0.0-solaris.patch
	"${FILESDIR}"/${PN}-1.0.0-darwin.patch
)

src_prepare() {
	default
	eautoreconf

	append-cppflags "-I${S}"
}

multilib_src_configure() {
	ECONF_SOURCE="${S}"	econf \
		--disable-static \
		--without-debug \
		--disable-gtk \
		$([[ ${CHOST} == *86*-darwin* ]] && echo "--disable-asm")

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
