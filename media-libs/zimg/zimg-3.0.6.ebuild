# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/sekrit-twc/zimg"
	inherit git-r3
else
	SRC_URI="https://github.com/sekrit-twc/zimg/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
	S="${WORKDIR}/${PN}-release-${PV}/"
fi
inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Scaling, colorspace conversion, and dithering library"
HOMEPAGE="https://github.com/sekrit-twc/zimg"

LICENSE="WTFPL-2"
SLOT="0"

IUSE="debug static-libs test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

PATCHES=(
	"${FILESDIR}/system-gtest.patch"
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	# Bump c++ standard for gtest
	# bug #959431
	append-cxxflags -std=c++17

	ECONF_SOURCE="${S}" econf \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_enable test unit-test)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
