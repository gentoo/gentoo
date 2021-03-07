# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1 optfeature

MY_PV="${PV//_beta/b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="The uncompromising Python code formatter"
HOMEPAGE="https://black.readthedocs.io/en/stable/ https://github.com/psf/black"
SRC_URI="https://github.com/psf/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"
IUSE="test"
# bug #754201
RESTRICT="test"

RDEPEND="
	>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]
	>=dev-python/toml-0.10.1[${PYTHON_USEDEP}]
	dev-python/typed-ast[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.7.4[${PYTHON_USEDEP}]
	>=dev-python/mypy_extensions-0.4.3[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/dataclasses[${PYTHON_USEDEP}]' python3_6)
"
BDEPEND="${RDEPEND}
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/aiohttp-cors[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/black-20.8_beta1-setuptools_scm.patch"
)

distutils_enable_tests unittest

python_prepare_all() {
	local version_path
	version_path="$(grep '"write_to"' setup.py | \
		sed -r 's|[[:space:]]+"write_to": "([[:graph:]]+)",|\1|' \
		|| die "could not find path to write version to")"

	[[ -e ${version_path} ]] && die "could not find path to write version to"
	printf 'version = "%s"\n' "${MY_PV}" > "${version_path}" || die "error writing version"
	sed -e 's:setuptools_scm::' -i setup.cfg || die

	# don't version lock dependencies
	sed -r -e 's:("pathspec>.*), <[0-9.-]+:\1:' -i setup.py || die

	# make sure that setup.py can read version
	export MY_PV

	distutils-r1_python_prepare_all
}

python_test() {
	cp "${S}"/src/black_primer/primer.json "${BUILD_DIR}"/lib/black_primer/primer.json || die
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "blackd - HTTP API for black" dev-python/aiohttp dev-python/aiohttp-cors
}
