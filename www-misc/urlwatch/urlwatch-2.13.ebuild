# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6} )

inherit distutils-r1

DESCRIPTION="A tool for monitoring webpages for updates"
HOMEPAGE="https://thp.io/2008/urlwatch/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/minidb[${PYTHON_USEDEP}]
	<dev-python/pyyaml-5[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pycodestyle[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.md README.md )

python_test() {
	nosetests test || die "tests failed with ${EPYTHON}"
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		if ! has_version dev-python/chump; then
			elog "Install 'dev-python/chump' to enable Pushover" \
				"notifications support"
		fi
		if ! has_version dev-python/pushbullet-py; then
			elog "Install 'dev-python/pushbullet-py' to enable" \
				"Pushbullet notifications support"
		fi
		elog "HTML parsing can be improved by installing one of the following packages"
		elog "and changing the html2text subfilter parameter:"
		elog "dev-python/beautifulsoup:4"
		elog "app-text/html2text"
		elog "dev-python/html2text"
		elog "www-client/lynx"
	fi
}
