# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Displays dependency graphs of packages"
HOMEPAGE="https://github.com/bgloyer/pacvis.git"
SRC_URI="https://github.com/bgloyer/pacvis/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="www-servers/tornado[${PYTHON_USEDEP}]"
