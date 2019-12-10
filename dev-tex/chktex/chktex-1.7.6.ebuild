# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Checks latex source for common mistakes"
HOMEPAGE="http://www.nongnu.org/chktex/"
SRC_URI="http://download.savannah.gnu.org/releases/chktex/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc +pcre test"
RESTRICT="!test? ( test )"
# Tests fail without pcre. Enable pcre by default and make tests depend on it.
REQUIRED_USE="test? ( pcre )"

RDEPEND="virtual/latex-base
	dev-lang/perl
	pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}
	sys-apps/groff
	dev-texlive/texlive-fontsrecommended
	doc? ( dev-tex/latex2html )"

PATCHES=( "${FILESDIR}/${PN}-1.7.1-asneeded.patch"
	  "${FILESDIR}/tex-inputenc.patch" )
DOCS=( NEWS )
AT_M4DIR="${S}/m4"

src_configure() {
	export VARTEXFONTS="${T}/fonts" #538672

	local myeconfargs=(
		$(use_enable debug debug-info)
		$(use_enable pcre)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	autotools-utils_src_compile ChkTeX.dvi
	use doc && autotools-utils_src_compile html
}

src_install() {
	if use doc ; then
		HTML_DOCS=("${AUTOTOOLS_BUILD_DIR}/HTML/ChkTeX/")
		DOCS+=("${AUTOTOOLS_BUILD_DIR}/HTML/ChkTeX.tex")
	fi
	DOCS+=("${AUTOTOOLS_BUILD_DIR}/ChkTeX.dvi")
	autotools-utils_src_install
	doman *.1
}
