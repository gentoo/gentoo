# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools vala

DESCRIPTION="Intelligent recursive search/replace utility"
HOMEPAGE="https://rpl.sourceforge.net/ https://github.com/rrthomas/rpl"
SRC_URI="https://github.com/rrthomas/rpl/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# unable to cause tests to pass fully
RESTRICT="test"

RDEPEND="
	app-i18n/uchardet
	dev-libs/glib:2
	dev-libs/libpcre2:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
	$(vala_depend)
"

PATCHES=(
	"${FILESDIR}/${P}-uchardet-vala.patch"
)

src_prepare() {
	default
	eautoreconf
	vala_setup
	rm *_vala.stamp || die
}
