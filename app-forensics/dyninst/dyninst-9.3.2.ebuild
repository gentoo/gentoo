# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Tools for binary instrumentation, analysis, and modification"
HOMEPAGE="http://www.dyninst.org/dyninst"
SRC_URI="https://github.com/dyninst/dyninst/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
