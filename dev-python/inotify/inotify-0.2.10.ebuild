# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_9 )
inherit distutils-r1

DESCRIPTION="an efficient and elegant inotify"
HOMEPAGE="https://github.com/dsoprea/PyInotify"
SRC_URI="https://github.com/dsoprea/PyInotify/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/PyInotify-${PV}"

#tests don't work and I don't care
RESTRICT="test"
distutils_enable_tests pytest
