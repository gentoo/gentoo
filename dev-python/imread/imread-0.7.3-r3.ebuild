# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1

DESCRIPTION="Read Image Files"
HOMEPAGE="http://luispedro.org/software/imread/ https://github.com/luispedro/imread"
SRC_URI="https://github.com/luispedro/imread/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/libpng:=
	media-libs/libjpeg-turbo:=
	media-libs/libwebp:=
	media-libs/tiff:=
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs/source
distutils_enable_tests setup.py
