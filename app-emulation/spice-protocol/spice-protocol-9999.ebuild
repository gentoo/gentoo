# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/spice/spice-protocol.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://www.spice-space.org/download/releases/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

DESCRIPTION="Headers defining the SPICE protocol"
HOMEPAGE="https://spice-space.org/"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
	default
}
