# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1 eutils

DESCRIPTION="Python interface to xattr"
HOMEPAGE="https://pyxattr.k1024.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://pyxattr.k1024.org/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="doc test"

RDEPEND="sys-apps/attr"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( >=dev-python/sphinx-1.3.1[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.0-xattr_header.patch"
)

python_prepare_all() {
	sed -i -e 's:, "-Werror"::' setup.py || die
	# Bug 548486
	sed -e "s:html_theme = 'default':html_theme = 'classic':" \
		-i doc/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake doc
}

src_test() {
	# Perform the tests in /var/tmp; that location is more likely
	# to have xattr support than /tmp which is often tmpfs.
	local -x TEST_DIR=/var/tmp

	einfo 'Please note that the tests fail if xattrs are not supported'
	einfo 'by the filesystem used for /var/tmp.'
	distutils-r1_src_test
}

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
}
