# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/oniguruma/oniguruma-5.9.5.ebuild,v 1.10 2015/03/03 06:41:09 dlan Exp $

EAPI=4
# Needed for a sane .so versionning on fbsd, please dont drop
AUTOTOOLS_AUTORECONF=1

inherit eutils autotools-multilib

MY_P=onig-${PV}

DESCRIPTION="a regular expression library for different character encodings"
HOMEPAGE="http://www.geocities.jp/kosako3/oniguruma"
SRC_URI="http://www.geocities.jp/kosako3/oniguruma/archive/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="combination-explosion-check crnl-as-line-terminator static-libs"

PATCHES=( "${FILESDIR}"/${PN}-5.9.3-makefile.patch )
DOCS=( AUTHORS HISTORY README{,.ja} doc/{API,FAQ,RE}{,.ja} )

S=${WORKDIR}/${MY_P}

src_configure() {
	local myeconfargs=(
		$(use_enable combination-explosion-check)
		$(use_enable crnl-as-line-terminator)
	)
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install
	use static-libs || prune_libtool_files
}
