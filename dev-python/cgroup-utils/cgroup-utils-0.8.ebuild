# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Tools and libraries for control groups of Linux"
HOMEPAGE="https://github.com/peo3/cgroup-utils"
SRC_URI="https://github.com/peo3/cgroup-utils/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-0.8-tests-builddir.patch

	# Upstream: https://github.com/peo3/cgroup-utils/pull/12
	"${FILESDIR}"/${PN}-0.8-tests-mountpoint.patch
)

python_test() {
	sh ./test_all.sh || die
}
