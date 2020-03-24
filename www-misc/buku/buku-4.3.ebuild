# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Powerful command-line bookmark manager"
HOMEPAGE="https://github.com/jarun/buku"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"

RDEPEND="
	>=dev-python/beautifulsoup-4.6.0[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.0.1[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	test? (
		dev-python/attrs[${PYTHON_USEDEP}]
		>=dev-python/click-7.0[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		>=dev-python/py-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/pylint-1.7.2[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-4.2[${PYTHON_USEDEP}]
		>=dev-python/vcrpy-4.0.2[${PYTHON_USEDEP}]
	)
"

python_prepare() {
	distutils-r1_python_prepare_all

	# Remove support for bukuserver - complex depgraph which isn't all
	# sufficiently packaged in Gentoo
	sed -ie '/console_scripts/s/,.*/]/' setup.py || die
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/zsh/site-functions
	doins auto-completion/zsh/_*

	newbashcomp auto-completion/bash/buku-completion.bash "${PN}"

	doman buku.1
}

python_test() {
	# Explicitly enumerate tests to avoid tests that deal with bukuserver
	py.test -v "tests/test_"{BukuCrypt,bukuDb,buku,ExtendedArgumentParser,import_firefox_json}".py" || die
}
