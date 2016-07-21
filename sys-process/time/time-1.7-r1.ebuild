# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils autotools

DESCRIPTION="displays info about resources used by a program"
HOMEPAGE="https://www.gnu.org/directory/time.html"
SRC_URI="mirror://gnu/time/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${PV}-info-dir-entry.patch
	eautoreconf
}
