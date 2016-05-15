# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="PyBookReader-${PV}"

DESCRIPTION="A book reader for .fb2 .html and plain text (possibly gzipped)"
HOMEPAGE="http://pybookreader.narod.ru/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk[${PYTHON_USEDEP}]
	dev-libs/libxml2[python,${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
