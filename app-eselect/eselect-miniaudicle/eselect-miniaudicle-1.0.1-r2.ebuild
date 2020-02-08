# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Manages the /usr/bin/miniAudicle symlink"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/miniaudicle.eselect-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3"

S=${WORKDIR}

src_prepare() {
	# Fixes listing as described in bug 320189, not upstream yet
	eapply "${FILESDIR}"/miniaudicle-1.0.1_list.patch
	default
}

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/miniaudicle.eselect-${PV}" miniaudicle.eselect
}
