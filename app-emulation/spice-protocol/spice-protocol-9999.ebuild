# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} = *9999* ]]; then
	inherit git-2 autotools
	EGIT_REPO_URI="git://anongit.freedesktop.org/spice/spice-protocol"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://spice-space.org/download/releases/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

DESCRIPTION="Headers defining the SPICE protocol"
HOMEPAGE="http://spice-space.org/"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
	default
}
