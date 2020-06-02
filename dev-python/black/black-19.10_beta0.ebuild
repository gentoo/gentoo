# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit eutils distutils-r1

MY_PV="${PV//_beta/b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="The uncompromising Python code formatter"
HOMEPAGE="https://black.readthedocs.io/en/stable/ https://github.com/psf/black"
SRC_URI="https://github.com/psf/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/typed-ast[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/aiohttp-cors[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/black-19.10_beta0-setuptools_scm.patch"
)

distutils_enable_tests unittest

python_prepare_all() {
	local version_path
	version_path="$(grep '"write_to"' setup.py | \
		sed -r 's|[[:space:]]+"write_to": "([[:graph:]]+)",|\1|' \
		|| die "could not find path to write version to")"

	[[ -e ${version_path} ]] && die "could not find path to write version to"
	printf 'version = "%s"\n' "${MY_PV}" > "${version_path}" || die "error writing version"

	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" tests/test_black.py -v || die "tests failed with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "blackd - HTTP API for black" dev-python/aiohttp dev-python/aiohttp-cors
}
