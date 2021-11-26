# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7,8,9,10} )
inherit distutils-r1 toolchain-funcs

DESCRIPTION="ease the development of portable automated build systems"
HOMEPAGE="https://www.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/colorama
	dev-python/stevedore
	dev-python/distro
	!app-editors/e3"
DEPEND="${RDEPEND}
	test? (
		dev-python/requests-toolbelt
		dev-python/httpretty
		dev-vcs/subversion
		dev-python/tqdm
		dev-python/tomlkit
		dev-python/pyyaml
		dev-python/python-dateutil
		dev-python/mock
		dev-python/psutil
	)"
BDEPEND=""
REQUIRED_USE="x86? ( !test )"

PATCHES=(
	"${FILESDIR}"/${P}-distro.patch
	"${FILESDIR}"/${P}-test.patch
)

distutils_enable_tests --install pytest

src_prepare() {
	distutils-r1_src_prepare
}

src_compile() {
	local PLATFORM=x86_64-linux
	rm src/e3/os/data/rlimit* || die
	$(tc-getCC) ${CFLAGS} -o src/e3/os/data/rlimit-${PLATFORM} tools/rlimit/rlimit.c ${LDFLAGS}
	distutils-r1_src_compile
}
