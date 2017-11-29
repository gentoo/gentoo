# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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

PATCHES=("${FILESDIR}/${P}-hashlib-r2.patch")

src_prepare() {
	default

	sed '/python setup.py build/d' -i Makefile

	if use minimal; then
		elog "ipkg-upload is not installed when the \`minimal' USE flag is set.  If you"
		elog "need ipkg-upload then rebuild this package without the \`minimal' USE flag."
	fi
}

src_compile() {
	distutils-r1_src_compile
	emake CC="$(tc-getCC)"
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

	dobin ipkg-compare-versions
}

pkg_postinst() {
	elog "Consider installing sys-apps/fakeroot for use with the ipkg-build "
	elog "command, that makes it possible to build packages as a normal user."
}
