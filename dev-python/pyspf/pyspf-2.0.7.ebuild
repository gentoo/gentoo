# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyspf/pyspf-2.0.7.ebuild,v 1.4 2013/03/23 11:25:15 ago Exp $

EAPI="3"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 3.*"

inherit distutils

DESCRIPTION="Python implementation of the Sender Policy Framework (SPF) protocol"
HOMEPAGE="http://pypi.python.org/pypi/pyspf"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-python/authres
	|| ( dev-python/pydns:2 dev-python/pydns:0 )"
DEPEND="${DEPEND}
	test? ( dev-python/pyyaml )"

PYTHON_MODNAME="spf.py"

src_test() {
	pushd test &> /dev/null
	testing() {
		PYTHONPATH="$(ls -d ../build-${PYTHON_ABI}/lib*)" "$(PYTHON)" testspf.py || die
	}
	python_execute_function testing
	popd &> /dev/null
}
