# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="A library for wrapping and filling UTF-8 CJK text"
HOMEPAGE="https://f.gallai.re/cjkwrap https://gitlab.com/fgallaire/cjkwrap"
SRC_URI="https://github.com/fgallaire/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
