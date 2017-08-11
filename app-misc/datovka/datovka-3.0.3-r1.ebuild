# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="GUI to access Czech eGov \"Datove schranky\""
HOMEPAGE="https://labs.nic.cz/page/969/datovka/"
SRC_URI="https://www.nic.cz/public_media/datove_schranky/releases/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	media-fonts/dejavu
	>=net-libs/dslib-3.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
