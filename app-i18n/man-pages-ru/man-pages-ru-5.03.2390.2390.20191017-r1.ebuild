# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_rs 2- -)"

DESCRIPTION="A collection of Russian translations of Linux manual pages"
HOMEPAGE="http://man-pages-ru.sourceforge.net/"
SRC_URI="https://download.sourceforge.net/${PN}/source-tar/${PN}_${MY_PV}.tar.bz2"

LICENSE="FDL-1.3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="virtual/man"

S="${WORKDIR}/${PN}_${MY_PV}"

src_prepare() {
	default
	# Remove man page provided by sys-apps/shadow
	rm man5/passwd.5 || die
}

src_install() {
	insinto /usr/share/man/ru
	doins -r man*
	dodoc README
}
