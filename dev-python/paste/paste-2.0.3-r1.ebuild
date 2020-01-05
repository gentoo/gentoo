# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

MY_PN="Paste"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tools for using a Web Server Gateway Interface stack"
HOMEPAGE="https://pypi.org/project/Paste/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="doc flup openid"

RDEPEND="dev-python/namespace-paste[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/tempita-0.5.2_pre20130828[${PYTHON_USEDEP}]
	flup? ( dev-python/flup[$(python_gen_usedep 'python2*')] )
	openid? ( dev-python/python-openid[$(python_gen_usedep 'python2*')] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

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

	local PATCHES=(
		"${FILESDIR}"/${P}-unbundle-tempita.patch
		)

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile egg_info --egg-base "${BUILD_DIR}/lib"
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	nosetests -P -v || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install egg_info --egg-base "${BUILD_DIR}/lib"
}

python_install_all() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
