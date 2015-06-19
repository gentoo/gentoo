# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/freesteam/freesteam-9999.ebuild,v 1.2 2014/01/06 14:46:21 jlec Exp $

EAPI=5

inherit eutils multilib scons-utils toolchain-funcs subversion

DESCRIPTION="Open source implementation of IF97 steam tables"
HOMEPAGE="http://freesteam.sourceforge.net/"
SRC_URI=""
ESVN_REPO_URI=https://freesteam.svn.sourceforge.net/svnroot/freesteam/trunk

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sci-libs/gsl"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-flags.patch
		"${FILESDIR}"/${PN}-soname-symlinks.patch
	epatch_user
}

src_configure() {
	myesconsargs=(
		INSTALL_PREFIX=/usr
		INSTALL_LIB=/usr/$(get_libdir)
		INSTALL_ROOT="${D}"

		CC="$(tc-getCC)"
		SWIG=false
	)

	mkdir -p "${D}" || die
}

src_compile() {
	escons
}

src_install() {
	escons install
}
