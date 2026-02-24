# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a multilib-minimal

DESCRIPTION="An optimised MPEG Audio Layer 2 (MP2) encoder"
HOMEPAGE="https://www.twolame.org"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"
IUSE="+sndfile static-libs test"
REQUIRED_USE="test? ( sndfile )"
RESTRICT="!test? ( test )"

RDEPEND="sndfile? ( >=media-libs/libsndfile-1.0.25[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-lang/perl )
"

PATCHES=(
	# PR merged
	"${FILESDIR}"/${P}-fix_C23.patch
)

src_prepare() {
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
	use static-libs && lto-guarantee-fat

	local myeconfargs=(
		$(use_enable sndfile)
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	use static-libs && strip-lto-bytecode
	find "${ED}" -type f -name "*.la" -delete || die
}
