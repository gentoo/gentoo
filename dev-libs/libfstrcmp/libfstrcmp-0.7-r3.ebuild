# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Make fuzzy comparisons of strings and byte arrays"
HOMEPAGE="http://fstrcmp.sourceforge.net/"
SRC_URI="http://fstrcmp.sourceforge.net/fstrcmp-${PV}.D001.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/fstrcmp-${PV}.D001"

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc static-libs test"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

BDEPEND="
	sys-apps/groff
	doc? ( app-text/ghostscript-gpl )
	test? ( app-text/ghostscript-gpl )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-libtool.patch # 778371
	"${FILESDIR}"/${P}-docdir.patch # 853133
)

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
	find "${D}" -name '*.la' -delete || die
	if ! use static-libs ; then
		find "${D}" -name '*.a' -delete || die
	fi
	use doc && emake DESTDIR="${D}" install-doc
	einstalldocs
}
