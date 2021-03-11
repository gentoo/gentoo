# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="YAML parser/emitter that supports roundtrip comment preservation"
HOMEPAGE="https://pypi.org/project/ruamel.yaml/ https://sourceforge.net/p/ruamel-yaml"
# PyPI tarballs do not include tests
SRC_URI="mirror://sourceforge/ruamel-dl-tagged-releases/${MY_P}.tar.xz -> ${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="dev-python/namespace-ruamel[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml-clib[${PYTHON_USEDEP}]"
BDEPEND="test? (
	dev-python/ruamel-std-pathlib[${PYTHON_USEDEP}]
)"

PATCHES=(
	"${FILESDIR}"/${PN}-0.16.13-pypy3_collection_deprecation.patch
)

S="${WORKDIR}"/${MY_P}

distutils_enable_tests pytest

# Old PyYAML tests from lib/ require special set-up and are invoked indirectly
# via test_z_olddata, tell pytest itself to leave the subdir alone.
python_test() {
	epytest --ignore _test/lib/
}

python_install() {
	distutils-r1_python_install --single-version-externally-managed
	find "${ED}" -name '*.pth' -delete || die
}
