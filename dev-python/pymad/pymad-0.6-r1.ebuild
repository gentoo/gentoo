# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pymad/pymad-0.6-r1.ebuild,v 1.2 2015/04/08 08:04:52 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python wrapper for libmad MP3 decoding in python"
HOMEPAGE="http://www.spacepants.org/src/pymad/"
SRC_URI="http://www.spacepants.org/src/pymad/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libmad"
RDEPEND="${DEPEND}"

python_configure_all() {
	set -- "${PYTHON}" config_unix.py --prefix "${EPREFIX}/usr"
	echo "${@}"
	"${@}" || die "Configuration failed"
}
