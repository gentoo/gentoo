# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"

inherit cmake-multilib

DESCRIPTION="Argument Parser for Modern C++"
HOMEPAGE="https://github.com/p-ranav/argparse"
SRC_URI="https://github.com/p-ranav/argparse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
