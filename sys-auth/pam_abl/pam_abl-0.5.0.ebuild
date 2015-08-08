# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="${PN/_/-}"
MY_P="${MY_PN}-${PV}"

inherit flag-o-matic pam cmake-utils db-use multilib

DESCRIPTION="PAM module for blacklisting of hosts and users on repeated failed authentication attempts"
HOMEPAGE="http://pam-abl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-libs/pam-0.78-r2
	>=sys-libs/db-4.2.52_p2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_configure() {
	pammod_hide_symbols

	local mycmakeargs=(
		-DDB_INCLUDE_DIR=$(db_includedir)
		-DDB_LINK_DIR=/usr/$(get_libdir)
		-DDB_LIBRARY=$(db_libname)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodir $(getpam_mod_dir)
	mv "${D}"/usr/lib/security/*.so "${D}"/"$(getpam_mod_dir)" || die

	dodoc doc/*.txt README
}
