# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="The OpenAL Utility Toolkit"
HOMEPAGE="https://www.openal.org/"
SRC_URI="http://http.debian.net/debian/pool/main/f/${PN}/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=media-libs/openal-1.15.1
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# Link against openal and pthread
	sed -e 's/libalut_la_LIBADD = .*/& -lopenal -lpthread/' \
		-i src/Makefile.am || die
	AT_M4DIR="admin/autotools/m4" eautoreconf
}

src_install() {
	local HTML_DOCS=( doc/. )

	default

	find "${ED}" -name '*.la' -type f -delete || die
}
