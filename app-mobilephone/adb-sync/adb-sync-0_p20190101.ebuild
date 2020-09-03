# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit python-single-r1

COMMIT=fb7c549753de7a5579ed3400dd9f8ac71f7bf1b1

DESCRIPTION="Synchronize files between a PC and an Android device using ADB"
HOMEPAGE="https://github.com/google/adb-sync"
SRC_URI="https://github.com/google/adb-sync/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+channel"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	dev-util/android-tools
	channel? ( net-misc/socat )"
DEPEND=""

S="${WORKDIR}/adb-sync-${COMMIT}"

src_install() {
	dodoc README.md
	python_doscript adb-sync
	use channel && dobin adb-channel
}
