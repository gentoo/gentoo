# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MIN_VERSION="3.0.0"

inherit cmake-utils

DESCRIPTION="The Solidity Contract-Oriented Programming Language"
HOMEPAGE="https://github.com/ethereum/solidity"
SRC_URI="https://github.com/ethereum/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/jsoncpp:=
	dev-libs/boost:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# The build won't work without this file but it is missing from
	# the release tarball.
	#
	# Reported upstream: https://github.com/ethereum/solidity/issues/1183

	cp "${FILESDIR}"/${P}-commit_hash.txt "${S}"/commit_hash.txt || die "Could not copy commit hash"

	# Without this file the build is marked as a developer version
	# but it is missing from the release tarball.
	#
	# Reported upstream: https://github.com/ethereum/solidity/issues/1183

	touch "${S}"/prerelease.txt || die "Could not mark as release version"
}
