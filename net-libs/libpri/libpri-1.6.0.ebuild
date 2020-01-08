# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Primary Rate ISDN (PRI) library"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://downloads.asterisk.org/pub/telephony/${PN}/releases/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${PN}-1.4.13-multilib.patch"
	"${FILESDIR}/${PN}-1.6.0-respect-user-flags.patch"
	"${FILESDIR}/${PN}-1.4.13-no-static-lib.patch"
)

src_compile() {
	tc-export CC
	default
}
src_install() {
	emake INSTALL_PREFIX="${D}" LIBDIR="${D}/usr/$(get_libdir)" install
	dodoc ChangeLog README TODO
}
