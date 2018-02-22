# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

MY_P=llvm-${PV}
DESCRIPTION="A stand-alone install of the LLVM suite testing tool"
HOMEPAGE="https://llvm.org/"
SRC_URI="https://llvm.org/releases/${PV}/${MY_P}.src.tar.xz"
EGIT_REPO_URI="https://llvm.org/git/llvm.git
	https://github.com/llvm-mirror/llvm.git"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-fbsd"
IUSE="test"

S=${WORKDIR}/${MY_P}.src/utils/lit

# Tests require 'FileCheck' and 'not' utilities (from llvm)
DEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		sys-devel/llvm )"

# TODO: move the manpage generation here (from sys-devel/llvm)

python_test() {
	./lit.py -sv tests || die
}
