# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

MY_PN="WebTest"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Helper to test WSGI applications"
HOMEPAGE="https://pypi.org/project/WebTest/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/paste[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2[${PYTHON_USEDEP}]
	>=dev-python/waitress-0.8.5[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	app-arch/unzip
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyquery[${PYTHON_USEDEP}]
		dev-python/pastedeploy[${PYTHON_USEDEP}]
		dev-python/wsgiproxy2[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 )
	)"

PATCHES=(
	"${FILESDIR}/webtest-2.0.33-no-pylons-theme.patch"
)

distutils_enable_sphinx docs
distutils_enable_tests pytest

#python_test() {
#	distutils_install_for_testing
#	# Tests raise ImportErrors with our default PYTHONPATH.
#	local -x PYTHONPATH=
#	nosetests -v || die "Tests fail with ${EPYTHON}"
#}
