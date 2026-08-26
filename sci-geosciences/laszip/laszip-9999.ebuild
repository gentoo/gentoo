# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Library for free and lossless compression of the LAS LiDAR format"
HOMEPAGE="https://rapidlasso.de/"

MY_PN="LASzip"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LASzip/LASzip.git"
else
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}/releases/download/${PV}/${PN}-src-${PV}.tar.gz"
	S="${WORKDIR}/${PN}-src-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
