# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/man-pages-ru/man-pages-ru-3.71.2209.1992.20140911.ebuild,v 1.3 2015/01/10 19:21:52 zlogene Exp $

EAPI="5"

inherit versionator

MY_PV="$(replace_version_separator 1 . $(replace_all_version_separators -))"

DESCRIPTION="A collection of Russian translations of Linux manual pages"
HOMEPAGE="http://man-pages-ru.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${MY_PV}.tar.bz2"

LICENSE="FDL-1.3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND="virtual/man"

S="${WORKDIR}/${PN}_${MY_PV}"

src_install() {
	insinto /usr/share/man/ru
	doins -r man*
	dodoc README
}
