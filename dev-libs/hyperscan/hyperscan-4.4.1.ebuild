# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="High-performance regular expression matching library"
SRC_URI="https://github.com/01org/hyperscan/archive/v${PV}.tar.gz"
HOMEPAGE="https://01.org/hyperscan"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
