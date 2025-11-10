# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AWS C SDKUTILS: C99 library implementing AWS SDK specific utilities."
HOMEPAGE="https://github.com/awslabs/aws-c-sdkutils"
SRC_URI="https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="~amd64"

DEPEND="dev-libs/aws-c-common"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"
