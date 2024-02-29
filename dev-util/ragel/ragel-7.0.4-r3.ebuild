# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Compiles finite state machines from regular languages into executable code"
HOMEPAGE="https://www.colm.net/open-source/ragel/"
SRC_URI="https://www.colm.net/files/ragel/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc"

# Notes from bug #766090
# dev-libs/libxml2's xmllint ends up being called by asciidoc here
# app-text/dblatex too
# app-text/ghostscript-gpl too
BDEPEND="
	doc? (
		|| ( app-text/asciidoc dev-ruby/asciidoctor )
		app-text/dblatex
		app-text/ghostscript-gpl
		dev-libs/libxml2
		dev-texlive/texlive-latex
		dev-python/pygments
		>=media-gfx/fig2dev-3.2.9-r1
	)
"
DEPEND=">=dev-util/colm-0.14.7-r1"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.4-drop-julia-check.patch
	"${FILESDIR}"/${PN}-7.0.4-r2-link-colm-properly.patch
)

src_prepare() {
	default

	# Fix hardcoded search dir
	sed -i -e "s:\$withval/lib:\$withval/$(get_libdir):" configure.ac || die

	# Allow either asciidoctor or asciidoc
	# bug #733426
	sed -i -e 's/(\[ASCIIDOC\], \[asciidoc\], \[asciidoc\]/S([ASCIIDOC], [asciidoc asciidoctor]/' configure.ac || die

	eautoreconf
}

src_configure() {
	# We need to be careful with both ragel and colm.
	# See bug #858341, bug #883993 bug #924163.
	filter-lto
	append-flags -fno-strict-aliasing

	econf \
		--with-colm="${EPREFIX}/usr" \
		$(use_enable doc manual)
}

src_install() {
	default

	insinto /usr/share/vim/vimfiles/syntax
	doins ragel.vim

	find "${ED}" -name '*.la' -delete || die
}
