# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Tools and libraries for control groups of Linux"
HOMEPAGE="https://github.com/peo3/cgroup-utils"
SRC_URI="https://github.com/peo3/cgroup-utils/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8-tests-builddir.patch

	# Upstream: https://github.com/peo3/cgroup-utils/pull/12
	"${FILESDIR}"/${PN}-0.8-tests-mountpoint.patch
)

python_test() {
	sh ./test_all.sh || die
}
