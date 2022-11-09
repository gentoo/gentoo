# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Generates RFCs and IETF drafts from document source in XML"
HOMEPAGE="https://ietf-tools.github.io/xml2rfc/ https://github.com/ietf-tools/xml2rfc"
SRC_URI="https://github.com/ietf-tools/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

RESTRICT="!test? ( test )"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/PyPDF2[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		dev-python/dict2xml[${PYTHON_USEDEP}]
		dev-python/weasyprint[${PYTHON_USEDEP}]
		media-fonts/noto[cjk]
	)
"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/ConfigArgParse[${PYTHON_USEDEP}]
	dev-python/intervaltree[${PYTHON_USEDEP}]
	dev-python/google-i18n-address[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.1.2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.1.1[${PYTHON_USEDEP}]
	dev-python/pycountry[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/xml2rfc-Remove-broken-test.patch"
)

distutils_enable_tests setup.py

#src_test() {
	# https://github.com/ietf-tools/xml2rfc/issues/561
#	emake tests-no-network
#}
