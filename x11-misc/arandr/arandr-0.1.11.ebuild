# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Another XRandR GUI"
HOMEPAGE="https://christian.amsuess.com/tools/arandr/"
SRC_URI="https://christian.amsuess.com/tools/arandr/files/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc64 x86"

RDEPEND="
	dev-python/pygobject:3=[${PYTHON_USEDEP},cairo]
	x11-libs/gtk+:3[introspection]
	x11-apps/xrandr
"
BDEPEND="dev-python/docutils[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${PN}-0.1.10-manpages.patch" )
