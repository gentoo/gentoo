# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Powerful text-to-postscript converter"
HOMEPAGE="https://www.gnu.org/software/enscript/enscript.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~mips ppc ppc64 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="nls ruby"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.4-ebuild.st.patch
	"${FILESDIR}"/${PN}-1.6.5.2-php.st.patch
	"${FILESDIR}"/${PN}-1.6.4-fsf-gcc-darwin.patch
	"${FILESDIR}"/${PN}-1.6.2-implicit-function-decl.patch
	"${FILESDIR}"/${PN}-1.6.6-gcc15.patch
)

src_prepare() {
	default

	use ruby && eapply "${FILESDIR}"/enscript-1.6.2-ruby.patch

	sed -i src/tests/passthrough.test -e 's|tail +2|tail -n +2|g' || die
}

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog NEWS README* THANKS TODO

	insinto /usr/share/enscript/hl
	doins "${FILESDIR}"/ebuild.st

	if use ruby ; then
		insinto /usr/share/enscript/hl
		doins "${FILESDIR}"/ruby.st
	fi
}
