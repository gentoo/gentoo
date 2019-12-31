# Copyright 2011-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools multilib-minimal

DESCRIPTION="Google's C++ logging library"
HOMEPAGE="https://github.com/google/glog"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="gflags static-libs test"
RESTRICT="test"

RDEPENDS="sys-libs/libunwind[${MULTILIB_USEDEP}]
	gflags? ( dev-cpp/gflags[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( >=dev-cpp/gtest-1.8.0[${MULTILIB_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.0-fix-x32-build.patch
	"${FILESDIR}"/${PN}-0.4.0-errnos.patch
	"${FILESDIR}"/${PN}-0.4.0-fix-test-on-ports.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		ac_cv_lib_gflags_main="$(usex gflags)"
}

multilib_src_install_all() {
	einstalldocs

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
