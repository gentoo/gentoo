# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
CMAKE_BUILD_TYPE=Release

inherit cmake-utils linux-info python-single-r1

DESCRIPTION="Record and Replay Framework"
HOMEPAGE="https://rr-project.org/"
SRC_URI="https://github.com/mozilla/${PN}/archive/${PV}.tar.gz -> mozilla-${P}.tar.gz"

LICENSE="MIT BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="multilib test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	sys-libs/zlib
	dev-libs/capnproto
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	sys-devel/gdb[xml]"
# Add all the deps needed only at build/test time.
DEPEND+="
	test? (
		dev-python/pexpect[${PYTHON_USEDEP}]
		sys-devel/gdb[xml]
	)"

RESTRICT="test" # toolchain and kernel version dependent

PATCHES=(
	"${FILESDIR}"/${P}-ucontext_t.patch
	"${FILESDIR}"/${P}-c++14.patch
	"${FILESDIR}"/${P}-tgkill-glibc-2.30.patch
)

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="SECCOMP"
		linux-info_pkg_setup
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	sed -i 's:-Werror::' CMakeLists.txt || die #609192
}

src_test() {
	if has usersandbox ${FEATURES} ; then
		ewarn "Test suite fails under FEATURES=usersandbox (bug #632394). Skipping."
		return 0
	fi

	cmake-utils_src_test
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-Ddisable32bit=$(usex !multilib) #636786
	)

	cmake-utils_src_configure
}
