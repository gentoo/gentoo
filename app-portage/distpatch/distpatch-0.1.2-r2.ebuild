# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Distfile Patching Support for Gentoo Linux (tools)"
HOMEPAGE="https://github.com/rafaelmartins/distpatch"
SRC_URI="https://github.com/rafaelmartins/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${PN}-python3-support.patch" )

DEPEND="
	>=sys-apps/portage-2.1.8.3[${PYTHON_USEDEP}]
	dev-python/snakeoil[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	>=dev-util/diffball-1.0.1"
