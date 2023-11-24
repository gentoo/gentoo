# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="python3-discogs-client"
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/joalla/discogs_client.git"
	inherit git-r3
else
	inherit pypi
	KEYWORDS="amd64 arm64 ~x86"
fi

DESCRIPTION="Continuation of the official Python API client for Discogs"
HOMEPAGE="
	https://github.com/joalla/discogs_client/
	https://pypi.org/project/python3-discogs-client/
"

LICENSE="BSD-2"
SLOT="0"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
