# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AWS C Compression cross-platform algorithms."
HOMEPAGE="https://github.com/awslabs/aws-c-compression"
SRC_URI="https://github.com/awslabs/aws-c-compression/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="~amd64"

DEPEND="dev-libs/aws-c-common:="
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"
