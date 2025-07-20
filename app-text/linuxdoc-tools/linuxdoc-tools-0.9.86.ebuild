# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package perl-functions sgml-catalog-r1 toolchain-funcs

DESCRIPTION="Toolset for processing LinuxDoc DTD SGML files"
HOMEPAGE="https://gitlab.com/agmartin/linuxdoc-tools"
SRC_URI="https://gitlab.com/agmartin/linuxdoc-tools/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+ MIT SGMLUG"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

RDEPEND="
	|| ( app-text/openjade app-text/opensp )
	app-text/sgml-common
	dev-lang/perl:=
	sys-apps/groff
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/awk
	app-alternatives/lex
	doc? (
		dev-texlive/texlive-fontsrecommended
		virtual/latex-base
	)
"

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

	default
}

src_install() {
	default

	use doc && docompress -x /usr/share/doc/${PF}/example

	insinto /etc/sgml
	newins - linuxdoc.cat <<-EOF
		CATALOG "${EPREFIX}/usr/share/linuxdoc-tools/linuxdoc-tools.catalog"
	EOF
}

pkg_postinst() {
	latex-package_pkg_postinst
	sgml-catalog-r1_pkg_postinst
}

pkg_postrm() {
	latex-package_pkg_postrm
	sgml-catalog-r1_pkg_postrm
}
