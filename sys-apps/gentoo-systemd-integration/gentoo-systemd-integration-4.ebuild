# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils systemd

DESCRIPTION="systemd integration files for Gentoo"
HOMEPAGE="https://bitbucket.org/mgorny/gentoo-systemd-integration"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=sys-apps/systemd-207
	!sys-fs/eudev
	!sys-fs/udev"

src_configure() {
	local myeconfargs=(
		"$(systemd_with_unitdir)"
		# TODO: solve it better in the eclass
		--with-systemdsystemgeneratordir="$(systemd_get_utildir)"/system-generators
	)

	autotools-utils_src_configure
}
