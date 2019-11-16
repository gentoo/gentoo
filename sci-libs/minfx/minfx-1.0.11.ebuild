# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} pypy3 )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Numerical optimisation library"
HOMEPAGE="https://sourceforge.net/projects/minfx/"
SRC_URI="https://sourceforge.net/projects/${PN}/files/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
