# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#if LIVE
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}2.git"

inherit autotools git-r3
#endif

inherit fdo-mime systemd

DESCRIPTION="Intelligent PE executable wrapper for binfmt_misc"
HOMEPAGE="https://bitbucket.org/mgorny/pe-format2/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}2/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="!<sys-apps/openrc-0.9.4"

#if LIVE
KEYWORDS=
SRC_URI=

src_prepare() {
	eautoreconf
}
#endif

src_configure() {
	local myconf=(
		"$(systemd_with_unitdir)"
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	keepdir /var/lib
}

pkg_postinst() {
	ebegin "Calling pe-format2-setup to update handler setup"
	pe-format2-setup
	eend ${?}

	fdo-mime_desktop_database_update
}
