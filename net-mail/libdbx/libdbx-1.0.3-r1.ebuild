# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN="libdbx"
MYFILE="${MY_PN}_${PV}.tgz"

DESCRIPTION="Tools and library for reading Outlook Express mailboxes (.dbx format)"
HOMEPAGE="https://sourceforge.net/projects/ol2mbox"
SRC_URI="mirror://sourceforge/ol2mbox/${MYFILE}"
S="${WORKDIR}/${MY_PN}_${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

PATCHES=(
	"${FILESDIR}"/bad_c.patch
	"${FILESDIR}"/${P}-missing-include.patch
)

src_prepare() {
	default

	sed -i -e 's/-g/$(CFLAGS) $(LDFLAGS)/;s|gcc|$(CC)|g' Makefile || die
	tc-export CC
}

src_install() {
	dobin readoe readdbx
	dodoc README* AUTHORS FILE-FORMAT
}
