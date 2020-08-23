# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="ssl(+)"

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Modern command line HTTP client"
HOMEPAGE="https://httpie.org/ https://pypi.org/project/httpie/"
SRC_URI="https://github.com/jakubroztocil/httpie/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]"
DEPEND="test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_install_all() {
	newbashcomp extras/httpie-completion.bash http
	insinto /usr/share/fish/vendor_completions.d
	newins extras/httpie-completion.fish http.fish
	distutils-r1_python_install_all
}
