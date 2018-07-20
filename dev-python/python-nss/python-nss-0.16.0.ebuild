# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )	# still only supports py2

inherit distutils-r1 flag-o-matic versionator

MY_PV="$(replace_all_version_separators  '_' )"
DESCRIPTION="Python bindings for Network Security Services (NSS)"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Python_binding_for_NSS"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/security/${PN}/releases/PYNSS_RELEASE_${MY_PV}/src/${P}.tar.bz2"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="
	dev-libs/nspr
	dev-libs/nss
"
DEPEND="${RDEPEND}
	doc? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/epydoc[${PYTHON_USEDEP}]
	)"

DOCS="README doc/ChangeLog"

python_prepare_all() {
	append-cflags -fno-strict-aliasing
	# Remove test file using a dep, called nss-tools, unavailable in portage
	rm -f test/test_pkcs12.py || die
	sed -e '/import test_pkcs12/d' \
		-e '/suite.addTests(loader.loadTestsFromModule(test_pkcs12))/d' \
		-i test/run_tests || die

	# exclude tests due to absent shared lib file, libnssckbi.so
	sed -e 's:test_ocsp_default_responder:_&:' \
		-i test/test_ocsp.py || die
	sed -e 's:test_ssl:_&:' \
		-i test/test_client_server.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		einfo "Generating API documentation..."
		mkdir doc/html
		epydoc --html --docformat restructuredtext -o doc/html \
			"${BUILD_DIR}"/lib/nss
	fi
}

python_test() {
	"${PYTHON}" test/run_tests || die
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	use examples && local EXAMPLES=( doc/examples/. )

	distutils-r1_python_install_all
}
