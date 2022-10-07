# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python library to interface Python to a SiriL script"
HOMEPAGE="https://gitlab.com/free-astro/pysiril"
SRC_URI="https://gitlab.com/free-astro/pysiril/-/archive/V${PV//./_}/${PN}-V${PV//./_}.tar.bz2"
S="${WORKDIR}/${PN}-V${PV//./_}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="sci-astronomy/siril"
