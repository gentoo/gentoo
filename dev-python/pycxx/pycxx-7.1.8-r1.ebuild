# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Set of facilities to extend Python with C++"
HOMEPAGE="https://cxx.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/cxx/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc examples"

BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	' 3.12)
"

python_prepare_all() {
	rm -R Src/Python2/ || die

	# Without this, pysvn fails.
	# Src/Python3/cxxextensions.c: No such file or directory
	sed -e "/^#include/s:Src/::" -i Src/*.{c,cxx} || die "sed failed"

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	# Move misplaced files into place
	dodir "/usr/share/${EPYTHON}"
	mv "${D}/usr/CXX" "${D}/usr/share/${EPYTHON}/CXX" || die
}

python_install_all() {
	use doc && local HTML_DOCS=( Doc/. )
	if use examples ; then
		docinto examples
		dodoc -r Demo/Python3/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
