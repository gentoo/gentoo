# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="ICU Layout Engine API on top of HarfBuzz shaping library"
HOMEPAGE="http://www.harfbuzz.org https://github.com/behdad/icu-le-hb"
SRC_URI="https://github.com/behdad/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="icu"
SLOT="0"

KEYWORDS="amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	media-libs/harfbuzz:=[${MULTILIB_USEDEP}]
"

DEPEND="
	${RDEPEND}
	>=dev-libs/icu-58.1[${MULTILIB_USEDEP}]
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf
}
