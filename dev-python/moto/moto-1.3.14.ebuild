# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Mock library for boto"
HOMEPAGE="https://github.com/spulec/moto"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/aws-xray-sdk-python-0.93[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/backports-tempfile[${PYTHON_USEDEP}]' python3_{6,7})
	dev-python/cfn-python-lint[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.3.0[${PYTHON_USEDEP}]
	dev-python/cookies[${PYTHON_USEDEP}]
	dev-python/dicttoxml[${PYTHON_USEDEP}]
	>=dev-python/docker-py-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10.1[${PYTHON_USEDEP}]
	>=dev-python/jsondiff-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/boto-2.36.0[${PYTHON_USEDEP}]
	>=dev-python/boto3-1.9.201[${PYTHON_USEDEP}]
	>=dev-python/botocore-1.12.201[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/pretty-yaml[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-jose[${PYTHON_USEDEP}]
	>=dev-python/responses-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
	>=dev-python/six-1.9[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( ${RDEPEND}
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		>=dev-python/sure-1.4.11[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/moto-1.3.14-newer-botocore.patch"
	"${FILESDIR}/moto-1.3.14-tests.patch"
)

distutils_enable_tests nose

python_prepare_all() {
	sed -e 's|==|>=|' \
		-e '/cfn-lint/ d' \
		-i setup.py moto.egg-info/requires.txt || die

	# Disable tests that fail with network-sandbox.
	sed -e 's|^\(def \)\(test_context_manager()\)|\1_\2|' \
		-e 's|^\(def \)\(test_decorator_start_and_stop()\)|\1_\2|' \
		-i tests/test_core/test_decorator_calls.py || die

	# Disable tests that fail with userpriv.
	sed -e 's|^\(def \)\(test_invoke_function_from_sns()\)|\1_\2|' \
		-e 's|^\(def \)\(test_invoke_requestresponse_function()\)|\1_\2|' \
		-i tests/test_awslambda/test_lambda.py || die

	# these tests crash nose
	rm tests/test_xray/test_xray_client.py || die

	distutils-r1_python_prepare_all
}
