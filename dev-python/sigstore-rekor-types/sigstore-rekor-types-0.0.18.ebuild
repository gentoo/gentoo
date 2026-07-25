# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/trailofbits/sigstore-rekor-types
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python models for Rekor's API types"
HOMEPAGE="
	https://github.com/sigstore/sigstore-rekor-types/
	https://pypi.org/project/sigstore-rekor-types/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	>=dev-python/email-validator-2[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2[${PYTHON_USEDEP}]
"
