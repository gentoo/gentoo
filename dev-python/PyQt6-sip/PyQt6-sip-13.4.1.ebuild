# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

MY_P="${P/-/_}"

DESCRIPTION="sip module support for PyQt6"
HOMEPAGE="https://www.riverbankcomputing.com/software/sip/"
SRC_URI="$(pypi_sdist_url --no-normalize ${PN/-/_})"
S="${WORKDIR}/${P/-/_}"

LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="0"
KEYWORDS="~amd64"
