# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python2_7 python3_{5,6,7})
inherit distutils-r1

DESCRIPTION="Fix common misspellings in text files."
HOMEPAGE="https://github.com/codespell-project/codespell"
SRC_URI="https://github.com/${PN}-project/${PN}/archive/v${PVR}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
