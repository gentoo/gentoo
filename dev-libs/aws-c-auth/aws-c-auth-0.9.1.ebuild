# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AWS C Auth: C99 library implementation of AWS client-side authentication."
HOMEPAGE="https://github.com/awslabs/aws-c-auth"
SRC_URI="https://github.com/awslabs/aws-c-auth/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="~amd64"

DEPEND="dev-libs/aws-c-sdkutils:=
	dev-libs/aws-c-cal:=
	dev-libs/aws-c-http:="
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"
