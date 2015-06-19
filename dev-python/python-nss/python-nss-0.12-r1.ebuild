# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-nss/python-nss-0.12-r1.ebuild,v 1.1 2015/01/05 23:47:47 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

MY_PV="$(replace_all_version_separators  '_' )_0"
DESCRIPTION="Python bindings for Network Security Services (NSS)"
HOMEPAGE="http://www.mozilla.org/projects/security/pki/python-nss/"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/security/${PN}/releases/PYNSS_RELEASE_${MY_PV}/src/${P}.tar.bz2"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="dev-libs/nss
	dev-libs/nspr
	doc? ( dev-python/docutils[${PYTHON_USEDEP}]
			dev-python/epydoc[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

CFLAGS="${CFLAGS} -fno-strict-aliasing"
DOCS="README doc/ChangeLog"
# RHB #754750 ; bgo #390869
PATCHES=( "${FILESDIR}/python-nss-0.12-rsapssparams.patch" )

python_compile_all() {
	if use doc; then
		einfo "Generating API documentation..."
		mkdir doc/html
		epydoc --html --docformat restructuredtext -o doc/html \
			"${BUILD_DIR}"/lib/nss
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	use examples && local EXAMPLES=( doc/examples/. )

	distutils-r1_python_install_all
}
