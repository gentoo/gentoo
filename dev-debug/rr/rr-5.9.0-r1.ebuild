# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
CMAKE_BUILD_TYPE=Release

inherit cmake linux-info python-single-r1 systemd

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
	app-arch/zstd:=
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
	"${FILESDIR}"/${PN}-5.9.0-zen-workaround-service.patch
	"${FILESDIR}"/${PN}-5.9.0-glibc-2.42-termio.patch
)

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="SECCOMP"

		if use amd64 ; then
			CONFIG_CHECK+=" ~X86_MSR"
			WARNING_X86_MSR="X86_MSR is needed for rr-zen_workaround.py (AMD Zen CPUs)"
		fi

		linux-info_pkg_setup
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	sed -i 's:-Werror::' CMakeLists.txt || die # bug #609192
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
		# TODO: Could wire up bpf but USE=bpf feels wrong for that
		# as only introduced in 5.9.0 (e7d9e8fd023461feb01f5d2c7936fcf07df8ce05) which
		# says it's not "suitable for wide use at this point".
		-DBUILD_TESTS=$(usex test)
		-Ddisable32bit=$(usex !multilib) # bug #636786
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Upstream's CMake avoids stripping librrpreload at least, and
	# Fedora avoids stripping all libraries. Treat it like Valgrind
	# and play it safe.
	dostrip -x "/usr/$(get_libdir)/rr"

	python_fix_shebang "${ED}"/usr/bin/rr-collect-symbols.py
	python_newscript scripts/zen_workaround.py rr-zen_workaround.py
	systemd_newunit scripts/zen_workaround.service rr-zen_workaround.service
}
