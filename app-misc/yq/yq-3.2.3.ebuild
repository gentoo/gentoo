# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} pypy3 )
DISTUTILS_USE_PEP517=setuptools

inherit pypi distutils-r1

DESCRIPTION="Command-line YAML processor - jq wrapper for YAML documents"
HOMEPAGE="
	https://yq.readthedocs.io/
	https://github.com/kislyuk/yq/
	https://pypi.org/project/yq/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-misc/jq
	dev-python/argcomplete[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.11.6[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/yq-3.1.2-test.patch"
)

python_prepare_all() {
	sed -e 's:unittest.main():unittest.main(verbosity=2):' \
		-i test/test.py || die

	sed -r -e 's:[[:space:]]*"coverage",:: ; s:[[:space:]]*"flake8",::' \
		-i setup.py || die

	sed -e '/license_file/ d' -i setup.cfg || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" test/test.py </dev/null || die "tests failed under ${EPYTHON}"
}
