# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake llvm.org python-any-r1

DESCRIPTION="Polyhedral optimizations for LLVM"
HOMEPAGE="https://polly.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
# vendored isl (fork?)
LICENSE+=" MIT"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="+debug test"
RESTRICT="!test? ( test )"

DEPEND="
	~llvm-core/llvm-${PV}:${LLVM_MAJOR}=[debug=]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=( polly cmake )
llvm.org_set_globals

python_check_deps() {
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"
	)
	use test && mycmakeargs+=(
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	cmake_src_configure
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-polly
}
