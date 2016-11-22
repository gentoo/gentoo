# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Needed for a sane .so versionning on fbsd, please dont drop
inherit autotools multilib-minimal

MY_P=onig-${PV}

DESCRIPTION="a regular expression library for different character encodings"
HOMEPAGE="http://www.geocities.jp/kosako3/oniguruma"
SRC_URI="http://www.geocities.jp/kosako3/oniguruma/archive/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="combination-explosion-check crnl-as-line-terminator static-libs"

PATCHES=( "${FILESDIR}"/${PN}-5.9.3-makefile.patch )
DOCS=( AUTHORS HISTORY README{,.ja} doc/{API,FAQ,RE}{,.ja} )

S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable combination-explosion-check) \
		$(use_enable crnl-as-line-terminator)
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
