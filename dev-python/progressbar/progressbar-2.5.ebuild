# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Text progressbar library for python"
HOMEPAGE="https://pypi.org/project/progressbar/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 BSD )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
