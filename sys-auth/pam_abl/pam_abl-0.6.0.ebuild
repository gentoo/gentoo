# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_abl/pam_abl-0.6.0.ebuild,v 1.1 2015/05/21 03:12:04 vapier Exp $

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

S=${WORKDIR}

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

pkg_preinst() {
	if has_version "~${CATEGORY}/${PN}-0.5.0" ; then
		ewarn "Note: the 0.5.0 release named the module 'pam-abl.so' by accident; this version"
		ewarn "fixes that and uses 'pam_abl.so' again.  Please update your config files."
	fi
}
