# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1 multiprocessing

MY_P=llvm-${PV/_/}.src
DESCRIPTION="A stand-alone install of the LLVM suite testing tool"
HOMEPAGE="https://llvm.org/"
SRC_URI="https://releases.llvm.org/${PV}/${MY_P}.tar.xz"
S=${WORKDIR}/${MY_P}/utils/lit

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Tests require 'FileCheck' and 'not' utilities (from llvm)
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		sys-devel/llvm )"

# TODO: move the manpage generation here (from sys-devel/llvm)

src_unpack() {
	einfo "Unpacking parts of ${MY_P}.tar.xz ..."
	tar -xJf "${DISTDIR}/${MY_P}.tar.xz" "${MY_P}/utils/lit" || die
}

python_test() {
	local -x LIT_PRESERVES_TMP=1
	./lit.py -j "${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}" \
		-vv tests || die
}
