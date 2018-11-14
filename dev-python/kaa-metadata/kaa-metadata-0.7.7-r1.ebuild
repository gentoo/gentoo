# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit distutils-r1

DESCRIPTION="Powerful media metadata parser for media files in Python, successor of MMPython"
HOMEPAGE="http://www.freevo.org/ https://github.com/freevo/kaa-metadata"
SRC_URI="mirror://sourceforge/freevo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="css dvd"

DEPEND=">=dev-python/kaa-base-0.3.0[${PYTHON_USEDEP}]
	css? ( media-libs/libdvdcss )
	dvd? ( media-libs/libdvdread )"
RDEPEND="${DEPEND}"

python_prepare_all() {
	# Disable experimental exiv2 parser which fails to build.
	sed -e "s/-lexiv2/&_nonexistent/" -i setup.py || die "sed setup.py failed"
	distutils-r1_python_prepare_all
}
