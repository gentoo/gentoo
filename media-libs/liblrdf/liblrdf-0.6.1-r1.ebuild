# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Library for manipulation of RDF files in LADSPA plugins"
HOMEPAGE="https://github.com/swh/LRDF"
SRC_URI="https://github.com/swh/LRDF/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~loong ppc ppc64 x86"
IUSE="static-libs"

RDEPEND="
	media-libs/ladspa-sdk[${MULTILIB_USEDEP}]
	media-libs/raptor:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

S="${WORKDIR}/LRDF-${PV}"

src_prepare() {
	default
	sed -i -e 's:usr/local:usr:' examples/{instances,remove}_test.c || die #392221
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf $(use_enable static-libs static)
}

multilib_src_test() {
	has_version media-plugins/swh-plugins && default #392221
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
