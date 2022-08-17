# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="High performance speedtest.net CLI"
HOMEPAGE="https://github.com/taganaka/SpeedTest"
SNAPSHOT_COMMIT="0f63cfbf7ce8d64ea803bf143b957eae76323405"
SRC_URI="https://github.com/taganaka/SpeedTest/archive/${SNAPSHOT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	net-misc/curl
	dev-libs/libxml2:=
	dev-libs/openssl:0=
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/SpeedTest-${SNAPSHOT_COMMIT}"
