# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="a collection of tools that nobody thought to write when Unix was young"
HOMEPAGE="https://joeyh.name/code/moreutils/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 hppa ~ppc ~ppc64 x86 ~x86-linux"
IUSE="+doc +perl"

RDEPEND="
	perl? (
		dev-lang/perl
		dev-perl/IPC-Run
		dev-perl/Time-Duration
		dev-perl/TimeDate
	)"
DEPEND="
	app-admin/eselect
	doc? (
		dev-lang/perl
		>=app-text/docbook2X-0.8.8-r2
		app-text/docbook-xml-dtd:4.4
	)"

src_prepare() {
	# don't build manpages
	if ! use doc ; then
		sed -i -e '/^all:/s/$(MANS)//' -e '/man1/d' Makefile || die
	fi

	# don't install perl scripts
	if ! use perl ; then
		sed -i -e '/PERLSCRIPTS/d' Makefile || die
	fi

	default
}

src_compile() {
	tc-export CC
	emake CFLAGS="${CFLAGS}" DOCBOOKXSL=/usr/share/sgml/docbook/xsl-stylesheets PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" INSTALL_BIN=install install

	# sys-process is more advanced than parallel from moreutils, rename it
	if use doc; then
		mv "${ED}"/usr/share/man/man1/{,${PN}_}parallel.1 || die
	fi
	mv "${ED}"/usr/bin/{,${PN}_}parallel || die
}

pkg_postinst() {
	# try to make sure $EDITOR is valid for vipe (bug #604630)
	eselect editor update
}
