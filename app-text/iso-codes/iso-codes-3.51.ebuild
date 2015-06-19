# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/iso-codes/iso-codes-3.51.ebuild,v 1.13 2014/06/14 19:32:06 tetromino Exp $

EAPI="5"
inherit eutils

DESCRIPTION="ISO language, territory, currency, script codes and their translations"
HOMEPAGE="http://pkg-isocodes.alioth.debian.org/"
SRC_URI="http://pkg-isocodes.alioth.debian.org/downloads/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="
	app-arch/xz-utils
	sys-devel/gettext
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_prepare() {
	local linguas_bak=${LINGUAS}
	local mylinguas=""

	[[ -z ${LINGUAS} ]] && return

	for norm in iso_15924 iso_3166 iso_3166_2 iso_4217 iso_639 iso_639_3; do
		einfo "Preparing ${norm}"

		mylinguas=""
		LINGUAS=${linguas_bak}
		strip-linguas -i "${S}/${norm}"

		for loc in ${LINGUAS}; do
			mylinguas="${mylinguas} ${loc}.po"
		done

		sed -e "s:pofiles =.*:pofiles = ${mylinguas} ${NULL}:" \
			-e "s:mofiles =.*:mofiles = ${mylinguas//.po/.mo} ${NULL}:" \
			-i "${S}/${norm}/Makefile.am" "${S}/${norm}/Makefile.in" \
			|| die "sed in ${norm} folder failed"
	done
}
