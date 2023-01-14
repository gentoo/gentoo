# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Utility to download media contents from the web"
HOMEPAGE="https://you-get.org"
SRC_URI="https://github.com/soimort/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"
PROPERTIES="test_network"

RDEPEND="
	media-video/ffmpeg
"

distutils_enable_tests unittest
