# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python Cryptography Toolkit"
HOMEPAGE="http://www.dlitz.net/software/pycrypto/ https://pypi.python.org/pypi/pycrypto"
SRC_URI="http://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/${P}.tar.gz"

LICENSE="PSF-2 public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE="doc +gmp test"

RDEPEND="gmp? ( dev-libs/gmp:0= )"
DEPEND="${RDEPEND}
	doc? (
		dev-python/docutils[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/epydoc-3[${PYTHON_USEDEP}]' python2_7)
		)"

REQUIRED_USE="test? ( gmp )"

python_prepare_all() {
	local PATCHES=( "${FILESDIR}"/${P}-cross-compile.patch )
	# Fix Crypto.PublicKey.RSA._RSAobj.exportKey(format="OpenSSH") with Python 3
	# https://github.com/dlitz/pycrypto/commit/ab25c6fe95ee92fac3187dcd90e0560ccacb084a
	sed \
		-e "/keyparts =/s/'ssh-rsa'/b('ssh-rsa')/" \
		-e "s/keystring = ''.join/keystring = b('').join/" \
		-e "s/return 'ssh-rsa '/return b('ssh-rsa ')/" \
		-i lib/Crypto/PublicKey/RSA.py || die
	distutils-r1_python_prepare_all
}

python_configure_all() {
	# the configure does not interact with python in any way,
	# it just sets up the C header file.
	econf \
		$(use_with gmp) \
		--without-mpir
}

python_compile_all() {
	if use doc; then
		rst2html.py Doc/pycrypt.rst > Doc/index.html || die
		epydoc --config=Doc/epydoc-config --exclude-introspect="^Crypto\.(Random\.OSRNG\.nt|Util\.winrandom)$" || die
	fi
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	esetup.py test
}

python_install_all() {
	local DOCS=( ACKS ChangeLog README TODO )
	use doc && local HTML_DOCS=( Doc/apidoc/. Doc/index.html )

	distutils-r1_python_install_all
}
