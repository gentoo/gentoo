# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="https://github.com/Nicotine-Plus/nicotine-plus"
SRC_URI="https://github.com/Nicotine-Plus/nicotine-plus/archive/1.4.1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=dev-python/pygtk-2.24[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/nicotine-plus-${PV}"

src_install() {
	distutils-r1_src_install
	mv "${ED}/usr/share/doc/nicotine" "${ED}/usr/share/doc/${PF}" || die
}
