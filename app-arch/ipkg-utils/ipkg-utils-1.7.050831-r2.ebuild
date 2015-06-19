# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/ipkg-utils/ipkg-utils-1.7.050831-r2.ebuild,v 1.1 2014/12/26 18:13:08 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils toolchain-funcs versionator

MY_P="${PN}-$(get_version_component_range 3)"

DESCRIPTION="Tools for working with the ipkg binary package format"
HOMEPAGE="http://www.openembedded.org/"
SRC_URI="http://handhelds.org/download/packages/ipkg-utils/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~x86"
IUSE="minimal"

DEPEND="
	!minimal? (
		app-crypt/gnupg
		net-misc/curl
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-tar_call_fixes.patch"
	epatch "${FILESDIR}/${P}-hashlib.patch"

	sed '/python setup.py build/d' -i Makefile

	if use minimal; then
		elog "ipkg-upload is not installed when the \`minimal' USE flag is set.  If you"
		elog "need ipkg-upload then rebuild this package without the \`minimal' USE flag."
	fi
}

src_compile() {
	distutils-r1_src_compile
	emake CC="$(tc-getCC)" || die "emake failed"
}

python_install() {
	distutils-r1_python_install

	if use minimal; then
		rm "${ED}usr/bin/ipkg-upload" \
			"${D}$(python_get_scriptdir)/ipkg-upload" || die
	fi
}

src_install() {
	distutils-r1_src_install
}

pkg_postinst() {
	elog "Consider installing sys-apps/fakeroot for use with the ipkg-build command,"
	elog "that makes it possible to build packages as a normal user."
}
