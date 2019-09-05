# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1 git-r3 multiprocessing

DESCRIPTION="A stand-alone install of the LLVM suite testing tool"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://git.llvm.org/git/llvm.git
	https://github.com/llvm-mirror/llvm.git"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

S=${WORKDIR}/${P}/utils/lit

# Tests require 'FileCheck' and 'not' utilities (from llvm)
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		sys-devel/llvm )"

# TODO: move the manpage generation here (from sys-devel/llvm)

src_unpack() {
	git-r3_fetch
	git-r3_checkout '' '' '' utils/lit
}

python_test() {
	local -x LIT_PRESERVES_TMP=1
	./lit.py -j "${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}" \
		-vv tests || die
}
