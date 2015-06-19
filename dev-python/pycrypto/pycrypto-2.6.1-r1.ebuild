# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycrypto/pycrypto-2.6.1-r1.ebuild,v 1.3 2015/05/16 07:19:17 vapier Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python Cryptography Toolkit"
HOMEPAGE="http://www.dlitz.net/software/pycrypto/ http://pypi.python.org/pypi/pycrypto"
SRC_URI="http://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/${P}.tar.gz"

LICENSE="PSF-2 public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE="doc +gmp"

RDEPEND="gmp? ( dev-libs/gmp )"
DEPEND="${RDEPEND}
	doc? (
		dev-python/docutils[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/epydoc-3[${PYTHON_USEDEP}]' python2_7)
		)"

python_prepare_all() {
	epatch "${FILESDIR}"/${P}-cross-compile.patch
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
		rst2html.py Doc/pycrypt.rst > Doc/index.html
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
