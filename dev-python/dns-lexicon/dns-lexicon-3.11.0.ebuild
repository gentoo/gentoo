# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 optfeature

DESCRIPTION="Manipulate DNS records on various DNS providers in a standardized/agnostic way"
HOMEPAGE="https://pypi.org/project/dns-lexicon/"
SRC_URI="
	https://github.com/AnalogJ/lexicon/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"
S="${WORKDIR}/lexicon-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tldextract[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/boto3[${PYTHON_USEDEP}]
		dev-python/zeep[${PYTHON_USEDEP}]
		dev-python/vcrpy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# Requires the "localzone" module
	lexicon/tests/providers/test_localzone.py
	# Requires the "softlayer" module
	lexicon/tests/providers/test_softlayer.py
	# Requires the "transip" module
	lexicon/tests/providers/test_transip.py
	# Requires the "oci" module
	lexicon/tests/providers/test_oci.py
	# Uses tldextract which needs Internet access to download its database
	lexicon/tests/providers/test_auto.py
	# All recordings seem to be broken
	lexicon/tests/providers/test_namecheap.py
)

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		optfeature_header \
			"Install the following packages to enable support for additional DNS providers:"
		optfeature Gransy dev-python/zeep
		optfeature Route53 dev-python/boto3
		optfeature DDNS dev-python/dnspython
	fi
}
