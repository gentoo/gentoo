# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

MY_P="Paste-${PV}"
DESCRIPTION="Tools for using a Web Server Gateway Interface stack"
HOMEPAGE="https://pypi.org/project/Paste/"
SRC_URI="mirror://pypi/${MY_P::1}/${PN^}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris"

RDEPEND="dev-python/namespace-paste[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_prepare_all() {
	# TODO: 'Address already in use'
	sed -e 's:test_address_family_v4:_&:' \
		-i tests/test_httpserver.py || die

	# Remove a test that runs against the paste website.
	rm -f tests/test_proxy.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
