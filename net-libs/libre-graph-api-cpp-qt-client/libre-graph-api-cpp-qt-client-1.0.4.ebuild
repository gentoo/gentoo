# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="API for cloud collaboration inspired by the MS Graph API"
HOMEPAGE="https://github.com/owncloud/libre-graph-api-cpp-qt-client/"
SRC_URI="https://github.com/owncloud/libre-graph-api-cpp-qt-client/archive/refs/tags/v${PV}.tar.gz -> libre-graph-api-cpp-qt-client-${PV}.tar.gz"

S=${WORKDIR}/${P}/client
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="dev-qt/qtbase:6[gui,ssl]"
RDEPEND="${DEPEND}"
