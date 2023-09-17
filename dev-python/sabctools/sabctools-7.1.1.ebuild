# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_PN="sabctools"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Module providing raw yEnc encoding/decoding for SABnzbd"
HOMEPAGE="
	https://github.com/sabnzbd/sabctools/
	https://pypi.org/project/sabctools/
"
SRC_URI="
	https://github.com/sabnzbd/${MY_PN}/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="
	test? (
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/portend[${PYTHON_USEDEP}]
	)
"

DOCS=( README.md doc/yenc-draft.1.3.txt )

distutils_enable_tests pytest
