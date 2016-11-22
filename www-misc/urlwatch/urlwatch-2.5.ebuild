# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python{3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A tool for monitoring webpages for updates"
HOMEPAGE="https://thp.io/2008/urlwatch/ https://pypi.python.org/pypi/urlwatch"
SRC_URI="https://thp.io/2008/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/minidb[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	|| ( www-client/lynx app-text/html2text )
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

python_test() {
	nosetests test || die "tests failed with ${EPYTHON}"
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] && \
		! has_version dev-python/chump; then
		elog "Install 'dev-python/chump' to enable Pushover" \
			"notifications support"
	fi
}
