# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/man-pages-de/man-pages-de-1.7.ebuild,v 1.11 2015/03/31 16:55:31 vapier Exp $

EAPI=5

inherit eutils autotools

MY_P="${PN/-/}-${PV}"

DESCRIPTION="A somewhat comprehensive collection of Linux german man page translations"
HOMEPAGE="http://alioth.debian.org/projects/manpages-de/"
SRC_URI="http://manpages-de.alioth.debian.org/downloads/${MY_P}.tar.xz"

LICENSE="GPL-3+ man-pages GPL-2+ GPL-2 BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="virtual/man"
DEPEND="${RDEPEND}
	app-text/po4a"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.3-bzip2.patch

	# Use the same compression as every other manpage
	local PORTAGE_COMPRESS_LOCAL=${PORTAGE_COMPRESS-bzip2}
	if [[ ${PORTAGE_COMPRESS+set} == "set" ]] ; then
		PORTAGE_COMPRESS_LOCAL="#"
	fi
	if [[ ${PORTAGE_COMPRESS_FLAGS+set} != "set" ]] ; then
		case ${PORTAGE_COMPRESS_LOCAL} in
			bzip2|gzip)  local PORTAGE_COMPRESS_FLAGS_LOCAL="-9"
			;;
		esac
	fi
	sed -i -e "s/gzip --best/${PORTAGE_COMPRESS_LOCAL} ${PORTAGE_COMPRESS_FLAGS_LOCAL}/"\
		po/man{1,2,3,4,5,6,7,8}/Makefile.in po/common.mk || die
	eautoreconf
}

src_compile() { :; }

src_install() {
	emake mandir="${ED}"/usr/share/man install
	dodoc CHANGES README
}
