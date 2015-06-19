# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/kaa-metadata/kaa-metadata-0.7.7-r1.ebuild,v 1.5 2015/04/08 08:05:12 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit distutils-r1

DESCRIPTION="Powerful media metadata parser for media files in Python, successor of MMPython"
HOMEPAGE="http://freevo.sourceforge.net/kaa/"
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
