# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P="${PN}-v${PV}"
DESCRIPTION="library for Levenberg-Marquardt least-squares minimization and curve fitting"
HOMEPAGE="https://jugit.fz-juelich.de/mlz/lmfit"
SRC_URI="https://jugit.fz-juelich.de/mlz/lmfit/-/archive/v${PV}/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
)
