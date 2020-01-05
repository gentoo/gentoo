# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit distutils-r1 flag-o-matic

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Coroutine-based network library"
HOMEPAGE="http://gevent.org/ https://pypi.org/project/gevent/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	>=dev-libs/libev-4.23
	>=net-dns/c-ares-1.12
	>=dev-python/greenlet-0.4.13
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
	cd src/greentest || die

	GEVENT_RESOLVER=thread \
		"${PYTHON}" testrunner.py --config known_failures.py || die
	GEVENT_RESOLVER=ares GEVENTARES_SERVERS=8.8.8.8 \
		"${PYTHON}" testrunner.py --config known_failures.py \
		--ignore tests_that_dont_use_resolver.txt || die
	GEVENT_FILE=thread \
		"${PYTHON}" testrunner.py --config known_failures.py $(grep -l subprocess test_*.py) || die
}

python_install_all() {
	local DOCS=( AUTHORS README.rst )
	use doc && local HTML_DOCS=( doc/_build/html/. )
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
