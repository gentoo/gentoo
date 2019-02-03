# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=(python{3_4,3_5,3_6})

inherit eutils distutils-r1

DESCRIPTION="utility to download media contents from the web"
HOMEPAGE="http://www.soimort.org/you-get"
SRC_URI="https://github.com/soimort/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	virtual/ffmpeg
"
