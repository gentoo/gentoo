# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/handystats/handystats-1.11.1.ebuild,v 1.1 2015/06/30 05:45:32 patrick Exp $

EAPI=5

RESTRICT="test"
inherit cmake-utils

DESCRIPTION="C++ library for collecting user-defined in-process runtime statistics with low overhead."
HOMEPAGE="https://github.com/shindo/handystats"
SRC_URI="https://github.com/shindo/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${DEPEND}
	dev-cpp/gtest
	dev-libs/boost"
