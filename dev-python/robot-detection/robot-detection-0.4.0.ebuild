# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Module to detect if a given HTTP User Agent is a web crawler."
HOMEPAGE="https://github.com/rory/robot-detection"
SRC_URI="https://github.com/rory/robot-detection/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
