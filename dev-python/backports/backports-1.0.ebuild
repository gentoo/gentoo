# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Namespace for backported Python features"
HOMEPAGE="https://bitbucket.org/brandon/backports https://pypi.org/project/backports/"
SRC_URI="https://dev.gentoo.org/~radhermit/dist/${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"

RDEPEND="!<dev-python/backports-lzma-0.0.2-r1"
