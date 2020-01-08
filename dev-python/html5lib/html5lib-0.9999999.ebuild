# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_6 pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="HTML parser based on the HTML5 specification"
HOMEPAGE="https://github.com/html5lib/html5lib-python/ https://html5lib.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	# https://github.com/html5lib/html5lib-python/issues/224
	# https://bugs.gentoo.org/show_bug.cgi?id=571644
	has_version =dev-python/lxml-3.5.0 && \
		einfo "test are broken with dev-python/lxml-3.5.0" && \
		einfo "https://github.com/html5lib/html5lib-python/issues/224" && \
		return
	nosetests --verbosity=3 || die "Tests fail with ${EPYTHON}"
}
