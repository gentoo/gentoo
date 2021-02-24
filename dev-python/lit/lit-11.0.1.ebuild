# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 llvm.org

DESCRIPTION="A stand-alone install of the LLVM suite testing tool"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Tests require 'FileCheck' and 'not' utilities (from llvm)
BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		sys-devel/llvm )"

LLVM_COMPONENTS=( llvm/utils/lit )
llvm.org_set_globals

# TODO: move the manpage generation here (from sys-devel/llvm)

src_prepare() {
	cd "${WORKDIR}" || die
	distutils-r1_src_prepare
}

python_test() {
	local -x LIT_PRESERVES_TMP=1
	local litflags=$(get_lit_flags)
	./lit.py ${litflags//;/ } tests || die
}
