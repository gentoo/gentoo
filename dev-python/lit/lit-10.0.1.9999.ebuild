# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1 llvm.org multiprocessing

DESCRIPTION="A stand-alone install of the LLVM suite testing tool"
HOMEPAGE="https://llvm.org/"
LLVM_COMPONENTS=( llvm/utils/lit )
llvm.org_set_globals

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

# Tests require 'FileCheck' and 'not' utilities (from llvm)
BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		sys-devel/llvm )"

# TODO: move the manpage generation here (from sys-devel/llvm)

src_prepare() {
	cd "${WORKDIR}" || die
	distutils-r1_src_prepare
}

python_test() {
	local -x LIT_PRESERVES_TMP=1
	./lit.py -j "${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}" \
		-vv tests || die
}
