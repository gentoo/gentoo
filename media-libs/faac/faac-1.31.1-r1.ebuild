# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="Free MPEG-4 audio codecs by AudioCoding.com"
HOMEPAGE="https://www.audiocoding.com"
SRC_URI="https://github.com/knik0/faac/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}"/${PN}-${P}

LICENSE="LGPL-2.1 MPEG-4"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

PATCHES=(
	"${FILESDIR}"/${P}-unaligned.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf

	# do not build the frontend for non-native abis
	if ! multilib_is_native_abi; then
		sed -i -e 's/frontend//' Makefile || die
	fi
}

multilib_src_install_all() {
	einstalldocs

	# no static archives
	find "${ED}" -type f -name '*.la' -delete || die
}
