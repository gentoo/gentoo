# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoo-systemd-integration.git"
	inherit autotools git-r3
else
	SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

inherit systemd

DESCRIPTION="systemd integration files for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Systemd"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=">=sys-apps/systemd-207
	!sys-fs/eudev
	!sys-fs/udev"

if [[ ${PV} == 9999 ]]; then
	DEPEND+=" sys-devel/systemd-m4"
fi

src_prepare() {
	default
	[[ ${PV} != 9999 ]] || eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		# TODO: solve it better in the eclass
		--with-systemdsystemgeneratordir="$(systemd_get_utildir)"/system-generators
	)

	econf "${myeconfargs[@]}"
}
