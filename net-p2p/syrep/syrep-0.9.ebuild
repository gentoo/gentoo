# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="A generic file repository synchronization tool"
HOMEPAGE="http://0pointer.de/lennart/projects/syrep/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="sys-libs/zlib
	>=sys-libs/db-4.3
	doc? ( www-client/lynx )"

src_prepare() {
	default
	sed -i \
		-e "s/#if (DB_VERSION_MAJOR != 4).*/#if (DB_VERSION_MAJOR < 4)/" \
		configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc lynx) \
		--disable-xmltoman \
		--disable-subversion \
		--disable-gengetopt
}

src_install() {
	DOCS=( doc/README doc/*.txt )
	use doc && HTML_DOCS=( doc/*.{css,html} )
	default
}
