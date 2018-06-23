# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Application Introspection System"
HOMEPAGE="https://computation.llnl.gov/projects/caliper"
SRC_URI="https://github.com/LLNL/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	net-misc/curl
	sys-libs/libunwind
	dev-libs/papi
	"
RDEPEND="${DEPEND}"

#thttps://github.com/LLNL/Caliper/pull/23
#thttps://github.com/LLNL/Caliper/pull/24
#thttps://github.com/LLNL/Caliper/pull/25
PATCHES=( "${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-python2.patch"
	"${FILESDIR}/${P}-multilib.patch"
	)

S="${WORKDIR}/${P^c}"
