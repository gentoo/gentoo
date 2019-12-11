# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Autoresponder add on package for qmailadmin"
HOMEPAGE="http://inter7.com/software/"
SRC_URI="mirror://sourceforge/qmailadmin/${P}.tar.gz
	mirror://gentoo/${PN}_${PV}-1.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc s390 sh sparc x86"

RDEPEND="virtual/qmail"
PATCHES=(
	"${WORKDIR}/autorespond_2.0.4-1.diff"
)
DOCS=( README help_message qmail-auto ChangeLog )

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install () {
	into /var/qmail
	dobin autorespond
	doman *.1
	einstalldocs
}
