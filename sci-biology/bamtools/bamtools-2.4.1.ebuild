# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A programmer's API and an end-user's toolkit for handling BAM files"
HOMEPAGE="https://github.com/pezmaster31/bamtools"
SRC_URI="https://github.com/pezmaster31/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/jsoncpp-1.8.0
	sys-libs/zlib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.1-fix-build-system.patch
	"${FILESDIR}"/${PN}-2.4.1-fix-c++14.patch
)
