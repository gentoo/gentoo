# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="The Sandbox escapist tool"
HOMEPAGE="https://github.com/mgorny/unsandbox"
SRC_URI="https://github.com/mgorny/unsandbox/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""
