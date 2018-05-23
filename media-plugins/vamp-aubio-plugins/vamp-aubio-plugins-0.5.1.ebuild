# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit flag-o-matic toolchain-funcs multilib python-any-r1 waf-utils

DESCRIPTION="Onset detection, pitch tracking, note tracking and tempo tracking plugins"
HOMEPAGE="https://www.vamp-plugins.org/"
SRC_URI="https://aubio.org/pub/vamp-aubio-plugins/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=media-libs/aubio-0.4.1
	media-libs/vamp-plugin-sdk
	=sci-libs/fftw-3*"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	${PYTHON_DEPS}"
