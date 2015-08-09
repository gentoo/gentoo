# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="https://github.com/shazow/urllib3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ppc ppc64 x86"
IUSE="doc test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	$(python_gen_cond_dep \
		'dev-python/backports-ssl-match-hostname[${PYTHON_USEDEP}]' python2_7 pypy)"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		~www-servers/tornado-3.1.1[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy)
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# Replace bundled copy of dev-python/six
	cat > urllib3/packages/six.py <<-EOF
		from __future__ import absolute_import
		from six import *
	EOF

	sed -i 's:cover-min-percentage = 100::' setup.cfg || die
	# Fix tests
	sed -i 's/urllib3.packages.six/six/' test/test_retry.py || die

	# Reset source of objects.inv
	if use doc; then
		local PYTHON_DOC_ATOM=$(best_version --host-root dev-python/python-docs:2.7)
		local PYTHON_DOC_VERSION="${PYTHON_DOC_ATOM#dev-python/python-docs-}"
		local PYTHON_DOC="/usr/share/doc/python-docs-${PYTHON_DOC_VERSION}/html"
		local PYTHON_DOC_INVENTORY="${PYTHON_DOC}/objects.inv"
		sed -i "s|'python': ('http://docs.python.org/2.7', None|'${PYTHON_DOC}': ('${PYTHON_DOC_INVENTORY}'|" docs/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

src_test() {
	# multiprocessing causes tests competing for and address to fail
	local DISTUTILS_NO_PARALLEL_BUILD=1
	distutils-r1_src_test
}

python_test() {
	# pypy doesn't get started in suite
	if [[ "${EPYTHON}" == pypy ]]; then
		einfo "Tests stall under pypy"
	else
		nosetests -v || die "Tests fail with ${EPYTHON}"
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
