# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="A library for wrapping and filling UTF-8 CJK text"
HOMEPAGE="https://f.gallai.re/cjkwrap https://gitlab.com/fgallaire/cjkwrap"
SRC_URI="https://github.com/fgallaire/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
