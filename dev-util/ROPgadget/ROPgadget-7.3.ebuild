# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Search for gadgets in binaries to facilitate your ROP exploitation"
HOMEPAGE="https://shell-storm.org/project/ROPgadget/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/JonathanSalwan/ROPgadget"
else
	SRC_URI="https://github.com/JonathanSalwan/ROPgadget/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/capstone-5[python,${PYTHON_USEDEP}]
"

src_test() {
	pushd test-suite-binaries || die
	./test.sh || die
	popd || die
}
