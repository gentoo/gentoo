# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Extensible multimedia container format based on EBML"
HOMEPAGE="http://www.matroska.org/ https://github.com/Matroska-Org/libmatroska/"
SRC_URI="http://dl.matroska.org/downloads/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/6" # subslot = soname major version
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-linux"
IUSE="static-libs"

RDEPEND=">=dev-libs/libebml-1.3.4:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
