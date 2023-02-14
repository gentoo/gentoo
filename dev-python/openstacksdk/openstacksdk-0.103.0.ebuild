# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A collection of libraries for building applications to work with OpenStack"
HOMEPAGE="
	https://opendev.org/openstack/openstacksdk/
	https://github.com/openstack/openstacksdk/
	https://pypi.org/project/openstacksdk/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.13[${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/requestsexceptions-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/jsonpatch-1.20[${PYTHON_USEDEP}]
	>=dev-python/os-service-types-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth1-3.18.0[${PYTHON_USEDEP}]
	>=dev-python/munch-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-4.4.1[${PYTHON_USEDEP}]
	>=dev-python/jmespath-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.10.4[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-0.6.5[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.7.0[${PYTHON_USEDEP}]
	dev-python/importlib_metadata[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/ddt-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/prometheus_client-0.4.2[${PYTHON_USEDEP}]
		>=dev-python/oslo-config-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/statsd-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	# Internet?
	sed -e 's:test_create_dynamic_large_object:_&:' \
		-i openstack/tests/unit/cloud/test_object.py || die

	# TODO
	sed -e 's:test_generate_form:_&:' \
		-e 's:test_create_static_large_object:_&:' \
		-e 's:test_object_segment_retries:_&:' \
		-e 's:test_object_segment_retry_failure:_&:' \
		-e 's:test_slo_manifest_retry:_&:' \
		-i openstack/tests/unit/cloud/test_object.py || die

	# unhappy about paths due to test runner
	sed -e 's:test_method_not_supported:_&:' \
		-i openstack/tests/unit/test_exceptions.py || die
	sed -e 's:test_repr:_&:' \
		-i openstack/tests/unit/test_resource.py || die

	# requires hacking
	rm openstack/tests/unit/test_hacking.py || die

	distutils-r1_src_prepare
}

python_test() {
	# functional tests require cloud instance access
	eunittest -b openstack/tests/unit
}
