# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_REPO_URI="https://github.com/pathscale/libcxxrt.git"

[ "${PV%9999}" != "${PV}" ] && SCM="git-r3" || SCM=""

inherit flag-o-matic toolchain-funcs portability ${SCM} multilib-minimal

DESCRIPTION="C++ Runtime from PathScale, FreeBSD and NetBSD"
HOMEPAGE="https://github.com/pathscale/libcxxrt"
if [ "${PV%9999}" = "${PV}" ] ; then
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	DEPEND="app-arch/xz-utils"
else
	SRC_URI=""
fi

LICENSE="BSD-2"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
else
	KEYWORDS=""
fi
IUSE="+libunwind +static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="libunwind? ( || ( >=sys-libs/libunwind-1.0.1-r1[static-libs?,${MULTILIB_USEDEP}]
		sys-libs/llvm-libunwind[static-libs?,${MULTILIB_USEDEP}] ) )"
DEPEND="${RDEPEND}
	${DEPEND}"

DOCS=( AUTHORS COPYRIGHT README )

gcc_check() {
	if tc-is-gcc && [[ $(gcc-major-version) -lt 6 ]] && use test; then
		eerror "At least gcc-6 is required to run tests. Please switch to a newer"
		eerror "compiler before proceeding."
		die "gcc-6 required for tests"
	fi
}

pkg_pretend() {
	gcc_check
}

pkg_setup() {
	gcc_check
}

src_prepare() {
	cp "${FILESDIR}/Makefile" src/ || die
	cp "${FILESDIR}/Makefile.test" test/Makefile || die
	multilib_copy_sources
}

multilib_src_compile() {
	# Notes: we build -nodefaultlibs to avoid linking to gcc libs.
	# libcxxrt needs: dladdr (dlopen_lib), libunwind or libgcc_s and the libc.
	tc-export CC CXX AR
	append-ldflags "-Wl,-z,defs" # make sure we are not underlinked
	cd "${BUILD_DIR}/src"
	LIBS="$(dlopen_lib) -l$(usex libunwind unwind gcc_s) -lc" emake shared
	use static-libs && emake static
}

multilib_src_test() {
	cd "${BUILD_DIR}/test"
	LD_LIBRARY_PATH="${BUILD_DIR}/src:${LD_LIBRARY_PATH}" \
		LIBS="-L${BUILD_DIR}/src -lcxxrt -l$(usex libunwind unwind gcc_s) -lc" \
		emake check
}

multilib_src_install() {
	# TODO: See README. Maybe hide it in a subdir and let only libcxx know about
	# it. FreeBSD head installs it in /lib
	dolib.so src/${PN}.so*
	use static-libs && dolib.a src/${PN}.a
}

multilib_src_install_all() {
	einstalldocs
	insinto /usr/include/libcxxrt/
	doins src/cxxabi.h src/unwind*.h
}
