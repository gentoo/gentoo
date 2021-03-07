# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/spice/spice-protocol.git"
	SRC_URI=""
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
