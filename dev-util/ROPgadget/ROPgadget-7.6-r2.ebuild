# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Search for gadgets in binaries to facilitate your ROP exploitation"
HOMEPAGE="https://shell-storm.org/project/ROPgadget/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/JonathanSalwan/ROPgadget"
else
	SRC_URI="https://github.com/JonathanSalwan/ROPgadget/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64 arm64 ppc64 ~riscv x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/capstone[python,${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-7.7-aarch64.patch"
)

# Mnemonics changed from Capstone 5 to 6. This leads to false-positive failing
# tests. Reenable tests as soon as ROPgadget supports Capston 6 (which will be
# when Capstone 6 becomes stable).
RESTRICT="test"

python_test() {
	pushd test-suite-binaries || die
	./test.sh || die "Tests failed with ${EPYTHON}"
	popd || die
}
