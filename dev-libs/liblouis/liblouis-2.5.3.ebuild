# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liblouis/liblouis-2.5.3.ebuild,v 1.15 2015/04/08 17:51:56 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE='wide-unicode(+)'
DISTUTILS_OPTIONAL=1
inherit distutils-r1

DESCRIPTION="An open-source braille translator and back-translator"
HOMEPAGE="http://code.google.com/p/liblouis/"
SRC_URI="http://liblouis.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 sparc x86"
IUSE="python"
RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	default

	if use python; then
		pushd python > /dev/null
		distutils-r1_src_prepare
		popd > /dev/null
	fi
}

src_configure() {
	econf --enable-ucs4
}

src_compile() {
	default

	if use python; then
		pushd python > /dev/null
		# setup.py imports liblouis to get the version number,
		# and this causes the shared library to be dlopened
		# at build-time.  Hack around it with LD_PRELOAD.
		# Thanks ArchLinux.
		LD_PRELOAD+=':../liblouis/.libs/liblouis.so'
			distutils-r1_src_compile
		popd > /dev/null
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die

	if use python; then
		pushd python > /dev/null
		LD_PRELOAD+=':../liblouis/.libs/liblouis.so' \
			distutils-r1_src_install
		popd > /dev/null
	fi

	dodoc README AUTHORS NEWS ChangeLog || die
	dohtml doc/liblouis.html
}
