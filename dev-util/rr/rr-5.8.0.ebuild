# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
CMAKE_BUILD_TYPE=Release

inherit cmake linux-info python-single-r1

DESCRIPTION="Record and Replay Framework"
HOMEPAGE="https://rr-project.org/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/rr-debugger/rr"
	inherit git-r3
else
	SRC_URI="https://github.com/rr-debugger/${PN}/archive/${PV}.tar.gz -> mozilla-${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

# rr itself is MIT and BSD-2, but there's various bits under third-party too.
LICENSE="MIT BSD-2 GPL-2 ZLIB"
SLOT="0"
IUSE="multilib test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	dev-libs/capnproto:=
	sys-libs/zlib:=
"
RDEPEND="
	${DEPEND}
	dev-debug/gdb[xml]
"
# Add all the deps needed only at build/test time.
DEPEND+="
	test? (
		$(python_gen_cond_dep '
			dev-python/pexpect[${PYTHON_USEDEP}]
		')
		dev-debug/gdb[xml]
	)"

QA_FLAGS_IGNORED="
	usr/lib.*/rr/librrpage.so
	usr/lib.*/rr/librrpage_32.so
"

RESTRICT="test" # toolchain and kernel version dependent

PATCHES=(
	"${FILESDIR}"/${PN}-5.7.0-no-force-lto.patch
)

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="SECCOMP"
		linux-info_pkg_setup
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	sed -i 's:-Werror::' CMakeLists.txt || die #609192
}

src_test() {
	if has usersandbox ${FEATURES} ; then
		ewarn "Test suite fails under FEATURES=usersandbox (bug #632394). Skipping."
		return 0
	fi

	cmake_src_test
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-Ddisable32bit=$(usex !multilib) #636786
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	python_fix_shebang "${ED}"/usr/bin/rr-collect-symbols.py
	python_newscript scripts/zen_workaround.py rr-zen_workaround.py
}
