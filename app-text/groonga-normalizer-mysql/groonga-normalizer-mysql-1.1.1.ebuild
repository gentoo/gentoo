# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils autotools ltprune

DESCRIPTION="Groonga plugin that provides MySQL compatible normalizers"
HOMEPAGE="http://groonga.org/"
SRC_URI="http://packages.groonga.org/source/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-text/groonga"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
DOCS=( README.md )

src_prepare() {
	default_src_prepare
	eautoreconf
}

src_configure() {
	# ruby is only uses for tests
	econf --without-ruby
}

src_install() {
	default

	prune_libtool_files
	rm -r "${D}usr/share/doc/${PN}" || die
}
