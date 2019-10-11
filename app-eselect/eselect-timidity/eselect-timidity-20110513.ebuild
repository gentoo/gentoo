# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Manages configuration of TiMidity++ patchsets"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="mirror://gentoo/timidity.eselect-${PVR}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ppc ppc64 sparc x86"

RDEPEND=">=app-admin/eselect-1.2.3"
S="${WORKDIR}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/timidity.eselect-${PVR}" timidity.eselect
}
