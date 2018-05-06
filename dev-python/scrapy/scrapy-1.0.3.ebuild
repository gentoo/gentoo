# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite(+)"

inherit vcs-snapshot distutils-r1

DESCRIPTION="A high-level Python Screen Scraping framework"
HOMEPAGE="https://github.com/scrapy/scrapy/
	https://pypi.python.org/pypi/Scrapy/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boto doc ibl test ssl"

RDEPEND="
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	ibl? ( dev-python/numpy[${PYTHON_USEDEP}] )
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	boto? ( dev-python/boto[${PYTHON_USEDEP}] )
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-conch[${PYTHON_USEDEP}]
	dev-python/twisted-mail[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]
	>=dev-python/w3lib-1.8.0[${PYTHON_USEDEP}]
	dev-python/queuelib[${PYTHON_USEDEP}]
	>=dev-python/cssselect-0.9[${PYTHON_USEDEP}]
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	dev-python/service_identity[${PYTHON_USEDEP}]
	"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( ${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		=net-proxy/mitmproxy-0.10.1[${PYTHON_USEDEP}]
		=dev-python/netlib-0.10.1[${PYTHON_USEDEP}]
		dev-python/jmespath[${PYTHON_USEDEP}]
		dev-python/testfixtures[${PYTHON_USEDEP}]
		net-ftp/vsftpd )"
# pytest-twisted listed as a test dep but not in portage.
# Testsuite currently survives without it, so appears optional

REQUIRED_USE="test? ( ssl boto )"

python_prepare_all() {
	# https://github.com/scrapy/scrapy/issues/1464
	# Disable failing tests known to pass according to upstream
	# Awaiting a fix planned by package owner.
	sed -e 's:test_https_connect_tunnel:_&:' \
		-e 's:test_https_connect_tunnel_error:_&:' \
		-e 's:test_https_tunnel_auth_error:_&:' \
		-e 's:test_https_tunnel_without_leak_proxy_authorization_header:_&:' \
		-i tests/test_proxy_connect.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		PYTHONPATH="${S}" emake -C docs html || die "emake html failed"
	fi
}

python_test() {
	py.test ${PN} tests || die "tests failed"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
