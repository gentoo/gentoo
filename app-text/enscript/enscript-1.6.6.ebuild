# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Powerful text-to-postscript converter"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
HOMEPAGE="https://www.gnu.org/software/enscript/enscript.html"

KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="nls ruby"

DEPEND="
	sys-devel/flex
	sys-devel/bison
	nls? ( sys-devel/gettext )
"
RDEPEND="nls? ( virtual/libintl )"

src_prepare() {
	epatch "${FILESDIR}"/enscript-1.6.4-ebuild.st.patch
	epatch "${FILESDIR}"/enscript-1.6.5.2-php.st.patch
	use ruby && epatch "${FILESDIR}"/enscript-1.6.2-ruby.patch
	sed -i src/tests/passthrough.test -e 's|tail +2|tail -n +2|g' || die
	default
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
