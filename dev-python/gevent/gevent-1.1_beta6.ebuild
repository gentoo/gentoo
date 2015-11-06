# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 flag-o-matic

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Coroutine-based network library"
HOMEPAGE="http://gevent.org/ https://pypi.python.org/pypi/gevent/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-libs/libev
	>=net-dns/c-ares-1.10
	>=dev-python/greenlet-0.3.2
	virtual/python-greenlet[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

# Tests take long and fail terribly a few times.
# It also seems that they require network access.
RESTRICT="test"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	export LIBEV_EMBED="false"
	export CARES_EMBED="false"
	export EMBED="false"

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

	GEVENT_RESOLVER=thread \
		"${PYTHON}" testrunner.py --config ../known_failures.py || die
	GEVENT_RESOLVER=ares GEVENTARES_SERVERS=8.8.8.8 \
		"${PYTHON}" testrunner.py --config ../known_failures.py \
		--ignore tests_that_dont_use_resolver.txt || die
	GEVENT_FILE=thread \
		"${PYTHON}" testrunner.py --config ../known_failures.py $(grep -l subprocess test_*.py) || die
}

python_install_all() {
	DOCS+=( changelog.rst )
	use doc && local HTML_DOCS=( doc/_build/html/. )
	use examples && local EXMAPLES=( examples/. )

	distutils-r1_python_install_all
}
