# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

MY_PV="$(ver_rs 1 _)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Free MPEG-4 audio codecs by AudioCoding.com"
HOMEPAGE="https://www.audiocoding.com"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 MPEG-4"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #466984
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --disable-static

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
