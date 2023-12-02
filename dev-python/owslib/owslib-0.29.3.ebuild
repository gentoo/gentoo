# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=OWSLib-${PV}
DESCRIPTION="Library for client programming with Open Geospatial Consortium web service"
HOMEPAGE="
	https://geopython.github.io/OWSLib/
	https://github.com/geopython/owslib/
	https://pypi.org/project/OWSLib/
"
SRC_URI="
	https://github.com/geopython/${PN}/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="test"
PROPERTIES="test_network"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# connection errors
	tests/test_wfs_generic.py::test_xmlfilter_wfs_110
	tests/test_wfs_generic.py::test_xmlfilter_wfs_200
	tests/test_ogcapi_records_pycsw.py::test_ogcapi_records_pycsw
	tests/test_opensearch_pycsw.py::test_opensearch_creodias
	tests/test_ows_interfaces.py::test_ows_interfaces_csw
	tests/test_csw3_pycsw.py::test_csw_pycsw
	tests/test_csw_pycsw.py::test_csw_pycsw
	tests/test_csw_pycsw_skip_caps.py::test_csw_pycsw_skip_caps
	# different output from remote service, sigh
	tests/test_ogcapi_processes_pygeoapi.py::test_ogcapi_processes_pygeoapi
	# TODO
	tests/test_remote_metadata.py::TestOffline::test_wfs_{110,200}_remotemd_parse_{all,single}
	tests/test_remote_metadata.py::TestOffline::test_wms_130_remotemd_parse_{all,single}
)

python_test() {
	epytest -o addopts=
}
