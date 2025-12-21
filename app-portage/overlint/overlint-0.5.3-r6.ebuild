# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Simple tool for static analysis of overlays"
HOMEPAGE="https://cgit.gentoo.org/proj/overlint.git"
SRC_URI="https://www.hartwork.org/public/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"

RDEPEND="sys-apps/portage[${PYTHON_USEDEP}]"
