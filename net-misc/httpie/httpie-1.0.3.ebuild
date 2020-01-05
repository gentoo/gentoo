# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )
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
	>=dev-python/requests-2.19.1[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

# Extend list of expected strings in test
PATCHES=(
	"${FILESDIR}/${PN}-1.0.2-fix-test_ssl.patch"
	"${FILESDIR}/${PN}-1.0.3-test_binary.patch"
	"${FILESDIR}/${PN}-1.0.3-test_stream.patch"
)

python_test() {
	pytest -vv || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	newbashcomp extras/httpie-completion.bash http
	insinto /usr/share/fish/vendor_completions.d
	newins extras/httpie-completion.fish http.fish
	distutils-r1_python_install_all
}
