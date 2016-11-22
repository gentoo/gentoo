# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# EAPI=6 is blocked by Gentoo bugs 497038, 497052.
EAPI=5

inherit autotools-utils latex-package perl-functions sgml-catalog toolchain-funcs vcs-snapshot

DESCRIPTION="A toolset for processing LinuxDoc DTD SGML files"
HOMEPAGE="https://gitlab.com/agmartin/linuxdoc-tools"
SRC_URI="https://gitlab.com/agmartin/${PN}/repository/archive.tar.gz?ref=v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3+ MIT SGMLUG"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="
	|| ( app-text/openjade app-text/opensp )
	app-text/sgml-common
	dev-lang/perl:=
	|| ( sys-apps/gawk sys-apps/mawk )
	sys-apps/groff
"
DEPEND="${RDEPEND}
	sys-devel/flex
	doc? (
		dev-texlive/texlive-fontsrecommended
		virtual/latex-base
	)
"

src_prepare() {
	autotools-utils_src_prepare

	# Update the build system with Gentoo paths.
	sed -i \
		-e "s|share/doc/${PN}|share/doc/${PF}|g" \
		Makefile.in || die

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
	default_src_install
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
