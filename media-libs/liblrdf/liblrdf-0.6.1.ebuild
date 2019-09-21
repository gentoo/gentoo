# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library for manipulation of RDF files in LADSPA plugins"
HOMEPAGE="https://github.com/swh/LRDF"
SRC_URI="https://github.com/swh/LRDF/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static-libs"

RDEPEND="
	media-libs/ladspa-sdk
	media-libs/raptor:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

S="${WORKDIR}/LRDF-${PV}"

src_prepare() {
	default
	sed -i -e 's:usr/local:usr:' examples/{instances,remove}_test.c || die #392221
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	has_version media-plugins/swh-plugins && default #392221
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
