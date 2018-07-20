# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="GSD - file format specification and a library to read and write it"
HOMEPAGE="https://bitbucket.org/glotzer/gsd"
SRC_URI="https://glotzerlab.engin.umich.edu/Downloads/${PN}/${PN}-v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-v${PV}"
