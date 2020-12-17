# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/_/-}"
MY_P="${MY_PN}-${PV}"

inherit cmake db-use pam

DESCRIPTION="PAM module for blacklisting hosts and users repeatedly failed authentication"
HOMEPAGE="http://pam-abl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=sys-libs/pam-0.78-r2
	>=sys-libs/db-4.2.52_p2:="
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_configure() {
	pammod_hide_symbols

	local mycmakeargs=(
		-DDB_INCLUDE_DIR=$(db_includedir)
		-DDB_LINK_DIR=/usr/$(get_libdir)
		-DDB_LIBRARY=$(db_libname)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodir $(getpam_mod_dir)
	mv "${D}"/usr/lib/security/*.so "${D}"/"$(getpam_mod_dir)" || die

	dodoc doc/*.txt README
}
