# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit python-single-r1

COMMIT=b0a2a10

DESCRIPTION="Synchronize files between a PC and an Android device using ADB"
HOMEPAGE="https://github.com/google/adb-sync"
SRC_URI="https://github.com/google/adb-sync/tarball/${COMMIT} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+channel"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	dev-util/android-tools
	channel? ( net-misc/socat )"
DEPEND=""

S="${WORKDIR}/google-adb-sync-${COMMIT}"

src_install() {
	dodoc README.md
	python_doscript adb-sync
	use channel && dobin adb-channel
}
