# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 eutils

DESCRIPTION="Terminal spreadsheet multitool for discovering and arranging data"
HOMEPAGE="https://visidata.org"
SRC_URI="https://github.com/saulpw/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/python-dateutil[${PYTHON_USEDEP}]"
DEPEND=""
BDEPEND="
	test? (
		dev-vcs/git
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/openpyxl[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		$(python_gen_impl_dep sqlite)
		${RDEPEND}
	)
"

python_test() {
	rm tests/golden/load-http.tsv || die "Could not remove network-dependent test."
	git init || die "Git init failed."
	git add tests/golden/ || die "Git add failed."
	dev/test.sh || die "Tests failed."
	rm .git -rf || die "Could not clean up git test directory."
}

pkg_postinst() {
	optfeature "integration with yaml" dev-python/pyyaml
	optfeature "integration with pcap" dev-python/dnslib #dpkt pypcapkit
	optfeature "integration with png" dev-python/pypng
	optfeature "integration with http" dev-python/requests
	optfeature "integration with postgres" dev-python/psycopg
	optfeature "integration with xlsx" dev-python/openpyxl
	optfeature "integration with xls" dev-python/xlrd
	optfeature "integration with hdf5" dev-python/h5py
	optfeature "integration with ttf/otf" dev-python/fonttools
	optfeature "integration with xml/htm/html" dev-python/lxml
	optfeature "integration with dta (Stata)" dev-python/pandas
	optfeature "integration with shapefiles" sci-libs/pyshp
	optfeature "integration with namestand" dev-python/graphviz
	#optfeature "integration with mbtiles" mapbox-vector-tile
	#optfeature "integration with xpt (SAS)" xport
	#optfeature "integration with sas7bdat (SAS)" sas7bdat
	#optfeature "integration with sav (SPSS)" savReaderWriter
}
