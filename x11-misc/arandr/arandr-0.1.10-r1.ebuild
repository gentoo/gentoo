# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="no"
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Another XRandR GUI"
HOMEPAGE="https://christian.amsuess.com/tools/arandr/"
SRC_URI="https://christian.amsuess.com/tools/arandr/files/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	dev-python/pygobject:3=[${PYTHON_USEDEP},cairo]
	x11-apps/xrandr
"

BDEPEND="dev-python/docutils[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${PN}-0.1.10-manpages.patch" )
