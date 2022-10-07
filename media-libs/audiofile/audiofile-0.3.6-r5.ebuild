# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools gnome.org multilib-minimal

DESCRIPTION="An elegant API for accessing audio files"
HOMEPAGE="https://audiofile.68k.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/1" # subslot = soname major version
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="flac"

RDEPEND="flac? ( >=media-libs/flac-1.2.1:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.6-gcc6-build-fixes.patch
	"${FILESDIR}"/${PN}-0.3.6-CVE-2015-7747.patch
	"${FILESDIR}"/${PN}-0.3.6-mingw32.patch
	"${FILESDIR}"/${PN}-0.3.6-CVE-2017-68xx.patch
	"${FILESDIR}"/${PN}-0.3.6-CVE-2018-13440-CVE-2018-17095.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	# Tests depend on statically compiled binaries to work, so we'll have to
	# delete them later rather than not compile them at all
	local myconf=(
		--enable-largefile
		# static needed for tests, bug #869677
		--enable-static
		--disable-werror
		--disable-examples
		$(use_enable flac)
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_test() {
	emake check
}

multilib_src_install_all() {
	einstalldocs

	# package provides .pc file
	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -name '*.a' -delete || die
}
