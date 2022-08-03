# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1 optfeature

DESCRIPTION="A fast and simple micro-framework for small web-applications"
HOMEPAGE="
	https://bottlepy.org/
	https://github.com/bottlepy/bottle/
	https://pypi.org/project/bottle/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_tests unittest

BDEPEND="
	test? (
		dev-python/mako[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	sed -e '/scripts/d' -i setup.py || die

	# Remove test file requiring connection to network
	rm test/test_server.py || die
	distutils-r1_python_prepare_all
}

pkg_postinst() {
	optfeature "Templating support" dev-python/mako
	elog "Due to problems with bottle.py being in /usr/bin (see bug #474874)"
	elog "we do as most other distros and do not install the script anymore."
	elog "If you do want/have to call it directly rather than through your app,"
	elog "please use the following instead:"
	elog '  `python -m bottle`'
}
