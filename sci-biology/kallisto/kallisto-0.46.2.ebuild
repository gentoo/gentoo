# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Near-optimal RNA-Seq quantification"
HOMEPAGE="https://pachterlab.github.io/kallisto/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pachterlab/kallisto.git"
else
	SRC_URI="https://github.com/pachterlab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	sci-libs/hdf5:=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
