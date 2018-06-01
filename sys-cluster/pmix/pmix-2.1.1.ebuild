# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Process Management Interface (PMI) Exascale"
HOMEPAGE="https://pmix.github.io/pmix/"
SRC_URI="https://github.com/pmix/pmix/releases/download/v${PV}/${P}.tar.bz2"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +munge pmi"

RDEPEND="
	dev-libs/libevent:0=
	sys-cluster/ucx
	sys-libs/zlib:0=
	munge? ( sys-auth/munge )
	pmi? ( !sys-cluster/slurm )
	"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable pmi pmi-backward-compatibility) \
		$(use_with munge)
}
