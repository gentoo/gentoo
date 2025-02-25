# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {16..19} )
PYTHON_COMPAT=( python3_{10..13} )
inherit flag-o-matic llvm-r1 meson python-any-r1

DESCRIPTION="Tool to extract code content from source files"
HOMEPAGE="https://github.com/SUSE/clang-extract"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/SUSE/clang-extract.git"
	inherit git-r3
else
	CLANG_EXTRACT_COMMIT="8344124f604e2ef9202177f5b9ed61962a37c4dc"
	SRC_URI="
		https://github.com/SUSE/clang-extract/archive/${CLANG_EXTRACT_COMMIT}.tar.gz -> ${P}.gh.tar.gz
	"
	S="${WORKDIR}"/${PN}-${CLANG_EXTRACT_COMMIT}

	KEYWORDS="~amd64"
fi

LICENSE="UoI-NCSA"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/zstd:=
	sys-libs/zlib
	virtual/libelf
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/llvm:${LLVM_SLOT}
	')
"
RDEPEND="${DEPEND}"
BDEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
	test? ( ${PYTHON_DEPS} )
"

PATCHES=(
	"${FILESDIR}"/${PN}-meson.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
	llvm-r1_pkg_setup
}

src_prepare() {
	default

	# There's no need to manually add --gcc-install-dir to Clang invocations;
	# we already have this setup properly via our Clang config files in
	# /etc/clang.
	sed -i -e '/add_project_argument.*gcc-install-dir/d' meson.build || die

	# Testsuite makes some (bad) assumptions about layout
	BUILD_DIR="${S}"/build
}

src_configure() {
	# Use whatever CC/CXX llvm-r1 found for us, as meson.build
	# asserts on GCC being used.
	export CC=clang
	export CXX=clang++
	export PKG_CONFIG_PATH="$(get_llvm_prefix)/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	# User flags may be expecting GCC
	strip-unsupported-flags

	meson_src_configure
}

src_test() {
	# These hacks are inspired by dev-util/clazy.
	#
	# clang-extract wants to be installed in the directory of the clang binary,
	# so it can find the llvm/clang via relative paths.
	#
	# Setup the directories and symlink the system include dir for that.
	local -x LLVM_ROOT="$(get_llvm_prefix)"
	local -x CLANG_ROOT="${LLVM_ROOT//llvm/clang}"

	mkdir -p "${BUILD_DIR}${CLANG_ROOT}" || die
	ln -s "${CLANG_ROOT}/include" "${BUILD_DIR}${CLANG_ROOT}/include" || die
	mkdir -p "${BUILD_DIR}${LLVM_ROOT}/bin" || die
	ln -s "${BUILD_DIR}"/clang-extract "${BUILD_DIR}${LLVM_ROOT}/bin" || die
	ln -s "${BUILD_DIR}"/ce-inline "${BUILD_DIR}${LLVM_ROOT}/bin" || die

	# Wrap runtest.py so we always pass -bin-path.
	#
	# This is gnarly but we already have to make sure it uses the
	# right Python, so it was quicker to just do the bash wrapper.
	mv testsuite/lib/runtest.py{,.real} || die
	cat <<-EOF > testsuite/lib/runtest.py || die
	#!/bin/bash
	export CLANG_NO_DEFAULT_CONFIG=1
	${EPYTHON} "${S}"/testsuite/lib/runtest.py.real \
		-bin-path "${BUILD_DIR}${LLVM_ROOT}/bin/" \
		"\$@"
	EOF
	chmod +x testsuite/lib/runtest.py || die

	local -x PATH="${BUILD_DIR}/${LLVM_ROOT}/bin:${BUILD_DIR}/bin:${PATH}"
	local -x LD_LIBRARY_PATH="${BUILD_DIR}/lib:${LD_LIBRARY_PATH}"

	meson_src_test
}
