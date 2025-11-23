# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AWS C Http: C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
HOMEPAGE="https://github.com/awslabs/aws-c-http"
SRC_URI="https://github.com/awslabs/aws-c-http/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="~amd64"

DEPEND="dev-libs/aws-c-common
	dev-libs/aws-c-compression
	dev-libs/aws-c-io"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"
