# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Single UNIX Specification, Version 4, 2016 Edition"
HOMEPAGE="https://www2.opengroup.org/ogsys/catalog/T101"
SRC_URI="http://pubs.opengroup.org/onlinepubs/9699919799/download/susv4tc2.tar.bz2"

LICENSE="sus4-copyright"
SLOT="4"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~x64-macos"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/susv4tc2"

src_install() {
	dodoc -r *
}
