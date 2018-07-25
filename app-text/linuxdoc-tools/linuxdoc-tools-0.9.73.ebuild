# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# EAPI=6 is blocked by Gentoo bugs 497038, 497052.
EAPI=5

inherit autotools latex-package perl-functions sgml-catalog toolchain-funcs

DESCRIPTION="A toolset for processing LinuxDoc DTD SGML files"
HOMEPAGE="https://gitlab.com/agmartin/linuxdoc-tools"
SRC_URI="https://gitlab.com/agmartin/linuxdoc-tools/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3+ MIT SGMLUG"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="
	|| ( app-text/openjade app-text/opensp )
	app-text/sgml-common
	dev-lang/perl:=
	sys-apps/groff
"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/awk
	doc? (
		dev-texlive/texlive-fontsrecommended
		virtual/latex-base
	)
"

src_prepare() {
	# Pregenerated configure scripts fail.
	eautoreconf
}

src_configure() {
	perl_set_version
	tc-export CC
	local myeconfargs=(
		--disable-docs
		--with-texdir="${TEXMF}/tex/latex/${PN}"
		--with-perllibdir="${VENDOR_ARCH}"
		--with-installed-iso-entities
	)
	use doc && myeconfargs+=(--enable-docs="txt pdf html")

	econf "${myeconfargs[@]}"
}

src_compile() {
	# Prevent access violations from bitmap font files generation.
	use doc && export VARTEXFONTS="${T}/fonts"
	default_src_compile
}

src_install() {
	# Makefile ignores docdir configuration option.
	emake DESTDIR="${D}" docdir="${EPREFIX}/usr/share/doc/${PF}" install
	dodoc ChangeLog README
}

sgml-catalog_cat_include "/etc/sgml/linuxdoc.cat" "/usr/share/${PN}/${PN}.catalog"

pkg_postinst() {
	latex-package_pkg_postinst
	sgml-catalog_pkg_postinst
}

pkg_postrm() {
	latex-package_pkg_postrm
	sgml-catalog_pkg_postrm
}
