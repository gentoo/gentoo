# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit eutils distutils-r1

DESCRIPTION="Set of facilities to extend Python with C++"
HOMEPAGE="http://cxx.sourceforge.net"
SRC_URI="mirror://sourceforge/cxx/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="doc examples"

python_prepare_all() {
	# Without this, pysvn fails.
	# Src/Python3/cxxextensions.c: No such file or directory
	sed -e "/^#include/s:Src/::" -i Src/*.{c,cxx} || die "sed failed"

	distutils-r1_python_prepare_all
}

python_install_all() {
	use doc && local HTML_DOCS=( Doc/. )
	use examples && local EXAMPLES=( Demo/Python{2,3}/. )
	distutils-r1_python_install_all
}
