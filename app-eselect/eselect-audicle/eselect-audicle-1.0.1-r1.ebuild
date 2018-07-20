# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Manages the /usr/bin/audicle symlink"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="mirror://gentoo/audicle.eselect-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3"

S="${WORKDIR}"

src_prepare() {
	default
	sed -i -e 's/highlight_maker/highlight_marker/' "${WORKDIR}/audicle.eselect-${PV}" || die
}

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/audicle.eselect-${PV}" audicle.eselect
}
