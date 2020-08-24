# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="The OpenAL Utility Toolkit"
HOMEPAGE="https://www.openal.org/"
SRC_URI="http://http.debian.net/debian/pool/main/f/${PN}/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=media-libs/openal-1.15.1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# Link against openal and pthread
	sed -e 's/libalut_la_LIBADD = .*/& -lopenal -lpthread/' \
		-i src/Makefile.am || die
	AT_M4DIR="admin/autotools/m4" eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --disable-static
}

multilib_src_install_all() {
	local HTML_DOCS=( doc/. )
	einstalldocs
	find "${D}" -name '*.la' -type f -delete || die
}
