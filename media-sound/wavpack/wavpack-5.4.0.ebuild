# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Hybrid lossless audio compression tools"
HOMEPAGE="https://www.wavpack.com/"
SRC_URI="https://github.com/dbry/WavPack/releases/download/${PV}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=virtual/libiconv-0-r1"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		$(use_enable test tests) \
		$(multilib_native_enable apps)
}

multilib_src_test() {
	cli/wvtest --default || die
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
