# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Make fuzzy comparisons of strings and byte arrays"
HOMEPAGE="http://fstrcmp.sourceforge.net/"

LICENSE="GPL-3+"
IUSE="doc test"
SLOT="0"

SRC_URI="http://fstrcmp.sourceforge.net/fstrcmp-0.7.D001.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/fstrcmp-0.7.D001"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-apps/groff
	doc? ( app-text/ghostscript-gpl )
	test? ( app-text/ghostscript-gpl )
"
RESTRICT="!test? ( test )"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake all-bin
	use doc && emake all-doc
}

src_install() {
	emake DESTDIR="${D}" install-bin install-include install-libdir install-man
	use doc && emake DESTDIR="${D}" install-doc
	einstalldocs
}
