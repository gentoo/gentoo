# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

MY_P=llvm-${PV/_/}
DESCRIPTION="A stand-alone install of the LLVM suite testing tool"
HOMEPAGE="https://llvm.org/"
SRC_URI="https://releases.llvm.org/${PV/_//}/${MY_P}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"

S=${WORKDIR}/${MY_P}.src/utils/lit

# Tests require 'FileCheck' and 'not' utilities (from llvm)
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		sys-devel/llvm )"

# TODO: move the manpage generation here (from sys-devel/llvm)

python_test() {
	./lit.py -sv tests || die
}
