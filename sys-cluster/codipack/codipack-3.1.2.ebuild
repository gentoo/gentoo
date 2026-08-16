# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="CoDiPack"

DESCRIPTION="Fast gradient evaluation in C++ based on Expression Templates"
HOMEPAGE="https://scicomp.rptu.de/software/codi/ https://github.com/SciCompKL/CoDiPack"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SciCompKL/${MY_PN}.git"
else
	SRC_URI="
		https://github.com/SciCompKL/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

RESTRICT="test"
