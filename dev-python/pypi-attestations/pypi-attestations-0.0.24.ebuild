# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Convert between Sigstore Bundles and PEP-740 Attestation objects"
HOMEPAGE="
	https://github.com/trailofbits/pypi-attestations/
	https://pypi.org/project/pypi-attestations/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	=dev-python/pyasn1-0.6*[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.10.0[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/rfc3986[${PYTHON_USEDEP}]
	<dev-python/sigstore-3.7[${PYTHON_USEDEP}]
	dev-python/sigstore-protobuf-specs[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
