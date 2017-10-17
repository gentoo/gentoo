# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Shared code for running pylint against rhinstaller projects"
HOMEPAGE="https://github.com/rhinstaller/pocketlint"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""
