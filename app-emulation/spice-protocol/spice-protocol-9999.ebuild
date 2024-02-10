# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/spice/spice-protocol.git"
else
	SRC_URI="https://www.spice-space.org/download/releases/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Headers defining the SPICE protocol"
HOMEPAGE="https://spice-space.org/"

LICENSE="BSD"
SLOT="0"
