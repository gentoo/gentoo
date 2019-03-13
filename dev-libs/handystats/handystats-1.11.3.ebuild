# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ library for collecting user-defined in-process runtime statistics"
HOMEPAGE="https://github.com/shindo/handystats"
SRC_URI="https://github.com/shindo/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"

DEPEND="
	dev-cpp/gtest
	dev-libs/boost"
