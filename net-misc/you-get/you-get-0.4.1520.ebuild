# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{7,8,9})
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit eutils distutils-r1

DESCRIPTION="utility to download media contents from the web"
HOMEPAGE="https://you-get.org"
SRC_URI="https://github.com/soimort/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	media-video/ffmpeg
"
