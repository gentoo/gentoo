# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

#if LIVE
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}2.git"

inherit autotools git-r3
#endif

inherit systemd xdg-utils

DESCRIPTION="Intelligent PE executable wrapper for binfmt_misc"
HOMEPAGE="https://bitbucket.org/mgorny/pe-format2/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}2/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-util/desktop-file-utils"
RDEPEND="!<sys-apps/openrc-0.9.4"

#if LIVE
KEYWORDS=
SRC_URI=

src_prepare() {
	default
	eautoreconf
}
#endif

src_configure() {
	local myconf=(
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
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

	xdg_desktop_database_update
}
