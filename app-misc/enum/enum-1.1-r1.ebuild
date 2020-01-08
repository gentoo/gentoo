# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Replacement for GNU seq and BSD jot"
HOMEPAGE="https://github.com/hartwork/enum"
SRC_URI="https://github.com/hartwork/enum/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/asciidoc"
RDEPEND=""

DOCS=( ChangeLog )

src_prepare() {
	default

	# Remove bundled getopt
	rm -rv thirdparty || die

	# Workarund automake issues
	sed 's,\(AM_INIT_AUTOMAKE(\[\),\1subdir-objects ,' -i configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-doc-rebuild \
		--disable-dependency-tracking
}
