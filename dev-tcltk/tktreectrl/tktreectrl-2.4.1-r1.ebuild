# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit virtualx

DESCRIPTION="Flexible listbox widget for Tk"
HOMEPAGE="https://tktreectrl.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="tcltk"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug shellicon threads"

RDEPEND=">=dev-lang/tk-8.4:0="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/2.2.9-as-needed.patch )

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 # used to test for Large File Support
)

src_configure() {
	local myeconfargs=(
		$(use_enable threads)
		$(use_enable shellicon)
		$(use_enable amd64 64bit)
		$(use_enable debug symbols)
		--with-x
		--enable-shared
	)

	econf ${myeconfargs[@]}
}

src_test() {
	virtx emake test
}

src_install() {
	default
	mv \
		"${ED}"/usr/lib*/treectrl${PV}/htmldoc \
		"${ED}"/usr/share/doc/${PF}/ || die
}
