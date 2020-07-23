# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

# Need to fetch a commit because upstream didn't tag the minor release
COMMIT="e4e8d191e8dd74cbdbeaef3232c16a7ef517e68d"

DESCRIPTION="Hybrid lossless audio compression tools"
HOMEPAGE="https://www.wavpack.com/"
SRC_URI="https://github.com/dbry/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=virtual/libiconv-0-r1"
DEPEND="${RDEPEND}"

S="${WORKDIR}/WavPack-${COMMIT}"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf \
		--disable-static \
		$(use_enable test tests) \
		$(multilib_native_enable apps)
}

multilib_src_test() {
	cli/wvtest --default
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
