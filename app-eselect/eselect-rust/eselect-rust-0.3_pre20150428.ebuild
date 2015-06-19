# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-rust/eselect-rust-0.3_pre20150428.ebuild,v 1.1 2015/05/03 16:21:00 jauhien Exp $

EAPI=5

DESCRIPTION="eselect module for rust"
HOMEPAGE="http://github.com/jauhien/eselect-rust"
SRC_URI="https://github.com/jauhien/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-admin/eselect"

pkg_preinst() {
	if has_version 'app-eselect/eselect-rust' ; then
		eselect rust unset
	fi
}

pkg_postinst() {
	if has_version 'dev-lang/rust' || has_version 'dev-lang/rust-bin' ; then
		eselect rust update --if-unset
	fi
}

pkg_prerm() {
	eselect rust unset
}
