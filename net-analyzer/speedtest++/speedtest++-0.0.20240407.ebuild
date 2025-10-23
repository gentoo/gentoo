# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="High performance speedtest.net CLI"
HOMEPAGE="https://github.com/taganaka/SpeedTest"
SNAPSHOT_COMMIT="b743996d617e63c065b8552165954dfd2b1f2918"
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

PATCHES=( "${FILESDIR}"/"${P}"-cmake-4.patch )
