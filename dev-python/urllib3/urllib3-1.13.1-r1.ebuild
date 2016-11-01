# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="https://github.com/shazow/urllib3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc test"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/backports-ssl-match-hostname[${PYTHON_USEDEP}]' python2_7 pypy)
	$(python_gen_cond_dep 'dev-python/ndg-httpsclient[${PYTHON_USEDEP}]' python2_7 pypy)
	$(python_gen_cond_dep 'dev-python/pyasn1[${PYTHON_USEDEP}]' python2_7 pypy)
	"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=www-servers/tornado-4.2.1[$(python_gen_usedep 'python*')]
		>=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/nose-exclude-0.4.1[${PYTHON_USEDEP}]
	)
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	"

# Testsuite written requiring mock to be installed under all Cpythons

PATCHES=( "${FILESDIR}"/${P}-unbundle.patch )

python_prepare_all() {
	# Replace bundled copy of dev-python/six
	cat > urllib3/packages/six.py <<-EOF
		from __future__ import absolute_import
		from six import *
	EOF

	rm -r urllib3/packages/ssl_match_hostname || die
	cat > urllib3/packages/ssl_match_hostname.py <<- EOF
		from __future__ import absolute_import
		try:
		    from backports.ssl_match_hostname import CertificateError, match_hostname
		except ImportError:
		    from ssl import CertificateError, match_hostname
	EOF

	cat > urllib3/packages/ordered_dict.py <<- EOF
		from __future__ import absolute_import
		from collections import OrderedDict
	EOF

	sed \
		-e 's:\.packages\.six:six:g' \
		-e 's:\.six:six:g' \
		-i urllib3/util/response.py urllib3/response.py || die

	sed -i '/cover-min-percentage/d' setup.cfg || die
	# Fix tests
	sed -i 's/urllib3.packages.six/six/' test/test_retry.py || die

	# Reset source of objects.inv
	if use doc; then
		local PYTHON_DOC_ATOM=$(best_version --host-root dev-python/python-docs:2.7)
		local PYTHON_DOC_VERSION="${PYTHON_DOC_ATOM#dev-python/python-docs-}"
		local PYTHON_DOC="/usr/share/doc/python-docs-${PYTHON_DOC_VERSION}/html"
		local PYTHON_DOC_INVENTORY="${PYTHON_DOC}/objects.inv"
		sed \
			-e "s|'python': ('http://docs.python.org/2.7', None|'${PYTHON_DOC}': ('${PYTHON_DOC_INVENTORY}'|" \
			-i docs/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# Failures still occur under py2.7.
	# https://github.com/shazow/urllib3/issues/621

	[[ "${EPYTHON}" == pypy ]] && return

	nosetests -v \
		--exclude test_headerdict \
		--exclude test_headers \
		--exclude test_source_address_error \
		--exclude test_no_ssl \
		test || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
