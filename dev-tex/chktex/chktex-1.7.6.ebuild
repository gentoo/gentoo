# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Checks latex source for common mistakes"
HOMEPAGE="http://www.nongnu.org/chktex/"
SRC_URI="http://download.savannah.gnu.org/releases/chktex/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc +pcre test"
RESTRICT="!test? ( test )"
# Tests fail without pcre. Enable pcre by default and make tests depend on it.
REQUIRED_USE="test? ( pcre )"

RDEPEND="pcre? ( dev-libs/libpcre )"

DEPEND="${RDEPEND}
	sys-apps/groff
	dev-texlive/texlive-fontsrecommended
	doc? ( dev-tex/latex2html )"

BDEPEND="virtual/latex-base
	dev-lang/perl:="

PATCHES=( "${FILESDIR}/${PN}-1.7.1-asneeded.patch"
	  "${FILESDIR}/tex-inputenc.patch" )

AT_M4DIR="${S}/m4"

src_configure() {
	export VARTEXFONTS="${T}/fonts" #538672

	local myeconfargs=(
		$(use_enable debug debug-info)
		$(use_enable pcre)
	)
	econf ${myconfargs[@]}
}

src_compile() {
	default
	emake ChkTeX.dvi
	use doc && emake html
}

src_install() {
	default
	if use doc ; then
	      dodoc HTML/ChkTeX.tex
	fi
	dodoc ChkTeX.dvi NEWS
	doman *.1
}
