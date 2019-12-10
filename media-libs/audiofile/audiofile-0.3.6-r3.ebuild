# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome.org multilib-minimal

DESCRIPTION="An elegant API for accessing audio files"
HOMEPAGE="http://www.68k.org/~michael/audiofile/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/1" # subslot = soname major version
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="flac static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="flac? ( >=media-libs/flac-1.2.1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.6-gcc6-build-fixes.patch
	"${FILESDIR}"/${PN}-0.3.6-system-gtest.patch
	"${FILESDIR}"/${PN}-0.3.6-CVE-2015-7747.patch
	"${FILESDIR}"/${PN}-0.3.6-mingw32.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--enable-largefile
		--disable-werror
		--disable-examples
		$(use_enable flac)
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	einstalldocs

	# package provides .pc file
	find "${ED}" -name '*.la' -delete || die
}
