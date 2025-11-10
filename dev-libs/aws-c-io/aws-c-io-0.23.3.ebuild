# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AWS C IO: It handles all IO and TLS work for application protocols."
HOMEPAGE="https://github.com/awslabs/aws-c-io"
SRC_URI="https://github.com/awslabs/aws-c-io/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="~amd64"

DEPEND="dev-libs/aws-c-cal:=
	dev-libs/aws-c-common:=
	dev-libs/s2n-tls"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"
