# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A few really fast tools to convert, filter and update OSM data files"
HOMEPAGE="https://gitlab.com/osm-c-tools"
SRC_URI="https://gitlab.com/osm-c-tools/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eautoreconf
}
