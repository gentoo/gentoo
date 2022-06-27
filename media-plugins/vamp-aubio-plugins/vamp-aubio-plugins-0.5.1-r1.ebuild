# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( pypy3 python3_{7..9} )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils

WAF_PV='2.0.20'

DESCRIPTION="Onset detection, pitch tracking, note tracking and tempo tracking plugins"
HOMEPAGE="https://www.vamp-plugins.org/"
SRC_URI="https://aubio.org/pub/vamp-aubio-plugins/${P}.tar.bz2
	https://waf.io/waf-${WAF_PV}"

LICENSE="GPL-2"
SLOT="0"
# bug #748057, configure script only allows amd64/x86
KEYWORDS="-* amd64 -x86"
IUSE=""

DEPEND=">=media-libs/aubio-0.4.1
	media-libs/vamp-plugin-sdk
	=sci-libs/fftw-3*"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	${PYTHON_DEPS}"

src_prepare() {
	rm -r "${S}"/waflib && cp "${DISTDIR}/waf-${WAF_PV}" "${S}"/waf || die 'Failed to update waf'
	default
}
