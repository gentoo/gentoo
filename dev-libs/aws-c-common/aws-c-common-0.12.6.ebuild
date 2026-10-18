# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Core c99 package for AWS SDK for C"
HOMEPAGE="https://github.com/awslabs/aws-c-common"
SRC_URI="https://github.com/awslabs/aws-c-common/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake flag-o-matic

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="amd64"
IUSE="test"

RESTRICT="!test? ( test )"

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/967010
	# https://github.com/awslabs/aws-c-common/issues/1304
	filter-lto

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
