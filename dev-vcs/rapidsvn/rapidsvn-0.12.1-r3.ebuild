# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

WX_GTK_VER=3.0

inherit autotools eutils fdo-mime flag-o-matic python-single-r1 versionator wxwidgets

MY_PV=$(get_version_component_range 1-2)
MY_REL="1"

DESCRIPTION="Cross-platform GUI front-end for the Subversion revision system"
HOMEPAGE="http://rapidsvn.tigris.org/"
SRC_URI="
	http://www.rapidsvn.org/download/release/${PV}/${P}.tar.gz
	doc? ( https://dev.gentoo.org/~jlec/distfiles/svncpp.dox.xz )"

LICENSE="GPL-2 LGPL-2.1 FDL-1.2"
SLOT="0"
KEYWORDS="amd64 arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEP="
	${PYTHON_DEPS}
	dev-libs/apr
	dev-libs/apr-util
	dev-vcs/subversion
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${COMMON_DEP}
	doc? (
		dev-libs/libxslt
		app-text/docbook-sgml-utils
		app-doc/doxygen
		app-text/docbook-xsl-stylesheets
		media-gfx/graphviz
	)"
RDEPEND="${COMMON_DEP}"

DOCS=( HACKING.txt TRANSLATIONS )

src_prepare() {
	need-wxwidgets unicode
	if use doc; then
		mv "${WORKDIR}"/svncpp.dox doc/svncpp/ || die
	fi
	strip-linguas $(grep ^RAPIDSVN_LANGUAGES src/locale/Makefile.am | sed 's:RAPIDSVN_LANGUAGES=::g')
	sed \
		-e "/^RAPIDSVN_LANGUAGES/s:=.*:=${LINGUAS}:g" \
		-i src/locale/Makefile.am || die

	mv configure.in configure.ac || die
	epatch "${FILESDIR}/${P}-svncpp_link.patch"
	epatch "${FILESDIR}/${P}-locale.patch"
	epatch "${FILESDIR}/${P}-wx3.0.patch"
	epatch "${FILESDIR}/${P}-subversion1.9-private-api.patch"

	eautoreconf
}

src_configure() {
	append-cppflags $( apr-1-config --cppflags )
	econf \
		$(use_enable static-libs static) \
		$(use_with doc manpage) \
		$(use_with doc xsltproc) \
		$(use_with doc doxygen) \
		$(use_with doc dot) \
		--with-wx-config="${WX_CONFIG}" \
		--with-svn-lib="${EPREFIX}/usr/$(get_libdir)" \
		--with-svn-include="${EPREFIX}/usr/include" \
		--with-apr-config="${EPREFIX}/usr/bin/apr-1-config" \
		--with-apu-config="${EPREFIX}/usr/bin/apu-1-config"
}

src_compile() {
	default
	use doc && emake -C doc/manpage manpage
}

src_install() {
	default

	doicon src/res/rapidsvn.ico src/res/bitmaps/${PN}*.png
	make_desktop_entry rapidsvn "RapidSVN ${PV}" \
		"${EPREFIX}/usr/share/pixmaps/rapidsvn_32x32.png" \
		"RevisionControl;Development"

	if use doc ; then
		doman doc/manpage/${PN}.1
		dodoc doc/svncpp/html/*
	fi

	prune_libtool_files
}

src_test() {
	pushd src/tests/svncpp > /dev/null || die
	default
	./svncpptest | grep OK || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
