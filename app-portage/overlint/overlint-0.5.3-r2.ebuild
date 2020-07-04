# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Simple tool for static analysis of overlays"
HOMEPAGE="https://cgit.gentoo.org/proj/overlint.git"
SRC_URI="https://www.hartwork.org/public/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sys-apps/portage[${PYTHON_USEDEP}]"
