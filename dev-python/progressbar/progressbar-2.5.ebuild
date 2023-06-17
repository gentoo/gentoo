# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Text progressbar library for python"
HOMEPAGE="https://pypi.org/project/progressbar/"

LICENSE="|| ( LGPL-2.1 BSD )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
