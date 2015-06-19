# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/mitmproxy/mitmproxy-0.11.3.ebuild,v 1.1 2015/01/04 04:51:26 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

DESCRIPTION="An interactive, SSL-capable, man-in-the-middle HTTP proxy"
HOMEPAGE="http://mitmproxy.org/"
SRC_URI="http://mitmproxy.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND="
	>=dev-python/pillow-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/flask-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/configargparse-0.9.3[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.3.6[${PYTHON_USEDEP}]
	=dev-python/netlib-$(get_version_component_range 1-2)*[${PYTHON_USEDEP}]
	>dev-python/pyasn1-0.1.2[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.0.2[${PYTHON_USEDEP}]
	>=dev-python/urwid-1.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
		=www-servers/pathod-$(get_version_component_range 1-2)*[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# don't run example scripts tests
	rm test/test_examples.py || die

}

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGELOG CONTRIBUTORS )
	use doc && local HTML_DOCS=( doc/. )
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
