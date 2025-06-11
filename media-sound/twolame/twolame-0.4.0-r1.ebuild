# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="An optimised MPEG Audio Layer 2 (MP2) encoder"
HOMEPAGE="https://www.twolame.org"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="+sndfile static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="sndfile? ( >=media-libs/libsndfile-1.0.25[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-lang/perl )
"

src_prepare() {
	sed -i -e '/CFLAGS/s:-O3::' configure || die
	# remove -Werror, bug 493940
	sed -i -e '/WARNING_CFLAGS/s:-Werror::' configure || die

	if [[ ${CHOST} == *solaris* ]]; then
		# libsndfile doesn't like -std=c99 on Solaris
		sed -i -e '/CFLAGS/s:-std=c99::' configure || die
		# configure isn't really bourne shell (comment 0) or dash (comment 6)
		# compatible, bug #388885
		export CONFIG_SHELL="${BASH}"
	fi

	default
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable sndfile)
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}
