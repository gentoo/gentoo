# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sg3_utils/sg3_utils-1.37.ebuild,v 1.12 2014/01/26 12:19:06 ago Exp $

EAPI="4"

inherit eutils multilib

DESCRIPTION="Apps for querying the sg SCSI interface"
HOMEPAGE="http://sg.danny.cz/sg/"
SRC_URI="http://sg.danny.cz/sg/p/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="static-libs"

DEPEND="sys-devel/libtool"
RDEPEND=""
PDEPEND=">=sys-apps/rescan-scsi-bus-1.24"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.26-stdint.patch
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	dodoc COVERAGE doc/README examples/*.txt
	newdoc scripts/README README.scripts
	dosbin scripts/scsi*

	# Better fix for bug 231089; some packages look for sgutils2
	local path lib
	path="/usr/$(get_libdir)"
	for lib in "${ED}"/usr/$(get_libdir)/libsgutils2.*; do
		lib=${lib##*/}
		dosym "${lib}" "${path}/${lib/libsgutils2/libsgutils}"
	done

	prune_libtool_files
}
