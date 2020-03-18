# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module for downloading files"
HOMEPAGE="http://urlgrabber.baseurl.org"
SRC_URI="http://urlgrabber.baseurl.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86"
IUSE=""

DEPEND="dev-python/pycurl[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${P}.patch
	)
	distutils-r1_python_prepare_all
}
