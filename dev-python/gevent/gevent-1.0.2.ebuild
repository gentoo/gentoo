# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl"

inherit distutils-r1 flag-o-matic

MY_PV=${PV/_/}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Python networking library that uses greenlet to provide synchronous API"
HOMEPAGE="http://gevent.org/ https://pypi.python.org/pypi/gevent/"
SRC_URI="https://github.com/surfly/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="dev-libs/libev
	net-dns/c-ares
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

# Tests take long and fail terribly a few times.
# It also seems that they require network access.
RESTRICT="test"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	rm -r {libev,c-ares} || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	append-flags -fno-strict-aliasing
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	cd greentest || die
	"${PYTHON}" testrunner.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )

	distutils-r1_python_install_all

	dodoc changelog.rst

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
