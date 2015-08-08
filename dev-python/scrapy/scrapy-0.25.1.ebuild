# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite(+)"

inherit vcs-snapshot distutils-r1

DESCRIPTION="A high-level Python Screen Scraping framework"
HOMEPAGE="http://scrapy.org http://pypi.python.org/pypi/Scrapy/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boto doc ibl test ssl"

RDEPEND=">=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	ibl? ( dev-python/numpy[${PYTHON_USEDEP}] )
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	boto? ( dev-python/boto[${PYTHON_USEDEP}] )
	>=dev-python/twisted-core-10.0.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-conch-10.0.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-mail-10.0.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-web-10.0.0[${PYTHON_USEDEP}]
	>=dev-python/w3lib-1.6[${PYTHON_USEDEP}]
	dev-python/queuelib[${PYTHON_USEDEP}]
	>=dev-python/cssselect-0.9[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( ${RDEPEND}
		dev-python/boto[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		>=net-proxy/mitmproxy-0.10[${PYTHON_USEDEP}]
		net-ftp/vsftpd )"
# pytest-twisted listed as a test dep but not in portage.
# Testsuite currently survives without it, so appears optional

REQUIRED_USE="test? ( ssl boto )"

PATCHES=( "${FILESDIR}"/${PV}-setup.patch )

python_compile_all() {
	if use doc; then
		PYTHONPATH="${S}" emake -C docs html || die "emake html failed"
	fi
}

python_test() {
	py.test ${PN} || die "tests failed"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
