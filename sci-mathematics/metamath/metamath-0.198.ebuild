# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Proof verifier based on a minimalistic formalism"
HOMEPAGE="http://us.metamath.org/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}-exe.git"
else
	SRC_URI="https://github.com/${PN}/${PN}-exe/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-exe-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"

PATCHES=( "${FILESDIR}/dont_force_optimize.patch" )

src_prepare() {
	default
	eautoreconf
}
