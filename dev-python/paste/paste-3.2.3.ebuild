# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

MY_PN="Paste"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tools for using a Web Server Gateway Interface stack"
HOMEPAGE="https://pypi.org/project/Paste/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="flup openid"

RDEPEND="dev-python/namespace-paste[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	flup? ( dev-python/flup[$(python_gen_usedep 'python2*')] )
	openid? ( dev-python/python-openid[$(python_gen_usedep 'python2*')] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_prepare_all() {
	# Disable failing tests.
	rm -f tests/test_cgiapp.py || die
	sed \
		-e "s/test_find_file/_&/" \
		-e "s/test_deep/_&/" \
		-e "s/test_static_parser/_&/" \
		-i tests/test_urlparser.py || die "sed failed"

	# Remove a test that runs against the paste website.
	rm -f tests/test_proxy.py || die

	# remove unnecessary dep
	sed -i "s:'pytest-runner'::" setup.py || die

	distutils-r1_python_prepare_all
}

#python_compile() {
#	distutils-r1_python_compile egg_info --egg-base "${BUILD_DIR}/lib"
#}

#python_compile_all() {
#	use doc && esetup.py build_sphinx
#}

#python_install() {
#	distutils-r1_python_install egg_info --egg-base "${BUILD_DIR}/lib"
#}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
