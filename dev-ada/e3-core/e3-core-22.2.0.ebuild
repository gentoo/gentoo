# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 toolchain-funcs

DESCRIPTION="Ease the development of portable automated build systems"
HOMEPAGE="https://www.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="test"

RDEPEND="dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/stevedore[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	!app-editors/e3"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-python/httpretty[${PYTHON_USEDEP}]
		dev-vcs/subversion
		dev-python/mock[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-22.1.0-distro.patch
	"${FILESDIR}"/${PN}-22.1.0-test.patch
)

distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

src_compile() {
	local PLATFORM=x86_64-linux
	rm src/e3/os/data/rlimit* || die
	$(tc-getCC) ${CFLAGS} -o src/e3/os/data/rlimit-${PLATFORM} tools/rlimit/rlimit.c ${LDFLAGS}
	distutils-r1_src_compile
}
