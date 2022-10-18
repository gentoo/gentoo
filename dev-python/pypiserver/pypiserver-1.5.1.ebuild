# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Minimal PyPI server"
HOMEPAGE="
	https://github.com/pypiserver/pypiserver/
	https://pypi.org/project/pypiserver/
"
SRC_URI="
	https://github.com/pypiserver/pypiserver/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/bottle[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.25.0[${PYTHON_USEDEP}]
"
# NB: many test deps are optional/specific to tests we skip
BDEPEND="
	dev-python/setuptools-git[${PYTHON_USEDEP}]
	test? (
		>=dev-python/passlib-1.6[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst )

PATCHES=(
	"${FILESDIR}/${PN}-1.5.0-unbundle-bottle.patch"
)

distutils_enable_tests pytest

src_prepare() {
	# remove bundled bottle (sic!)
	rm pypiserver/bottle.py || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/test_server.py::test_hash_algos
		tests/test_server.py::test_pipInstall_openOk
		tests/test_server.py::test_pipInstall_authedOk
		# TODO
		tests/test_app.py::test_root_count
		tests/test_server.py::test_pip_install_open_succeeds
		tests/test_server.py::test_pip_install_authed_succeeds
		# seems to rely on internal bottle details
		tests/test_main.py::test_auto_servers
	)

	if ! has_version dev-python/twine; then
		EPYTEST_DESELECT+=(
			tests/test_server.py::test_twine_upload
			tests/test_server.py::test_twine_register
		)
	fi

	epytest tests
}
