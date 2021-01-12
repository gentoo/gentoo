# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="GSD - file format specification and a library to read and write it"
HOMEPAGE="https://github.com/glotzerlab/gsd"
SRC_URI="https://github.com/glotzerlab/gsd/releases/download/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]"
BDEPEND="
	${RDEPEND}"

S="${WORKDIR}/${PN}-v${PV}"
