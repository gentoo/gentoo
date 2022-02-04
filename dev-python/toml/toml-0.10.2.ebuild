# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1

TOML_TEST_VER="280497fa5f12e43d7233aed0d74e07ca61ef176b"

DESCRIPTION="Python library for handling TOML files"
HOMEPAGE="https://github.com/uiri/toml"
SRC_URI="https://github.com/uiri/${PN}/archive/${PV}.tar.gz -> ${P}-1.tar.gz
	test? ( https://github.com/BurntSushi/toml-test/archive/${TOML_TEST_VER}.tar.gz -> toml-test-${TOML_TEST_VER}.tar.gz )"
IUSE="test"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		' python3_{7..9})
	)"

DOCS=( README.rst )

distutils_enable_tests pytest

python_prepare_all() {
	if use test; then
		mv "${WORKDIR}/toml-test-${TOML_TEST_VER#v}" "${S}/toml-test" || die
	fi

	distutils-r1_python_prepare_all
}
