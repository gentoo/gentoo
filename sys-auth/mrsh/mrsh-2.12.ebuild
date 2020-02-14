# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="Mrsh is a set of remote shell programs that use munge authentication."
HOMEPAGE="https://github.com/chaos/mrsh"
SRC_URI="https://github.com/chaos/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pam shadow"
DEPEND="
	sys-auth/munge

	pam?	( sys-libs/pam )
	shadow?	( virtual/shadow )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/union-wait-deprecated.diff" )

src_configure() {
	local myconf=(
		--disable-static
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(use_with pam)
		$(use_with shadow)
	)
	econf "${myconf[@]}"
}
