# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils autotools

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
	eautoreconf
}

src_configure() {
	econf \
		--without-ruby19 \
		--docdir="${EROOT}usr/share/doc/${P}"
}

src_install() {
	default

	prune_libtool_files
	# Dont install README twice nor license
	rm -r "${D}usr/share/doc/${PN}" || die
}
