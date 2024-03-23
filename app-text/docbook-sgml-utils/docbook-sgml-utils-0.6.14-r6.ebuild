# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools prefix

MY_P=${PN/-sgml/}-${PV}
DESCRIPTION="Shell scripts to manage DocBook documents"
HOMEPAGE="https://sourceware.org/docbook-tools/"
SRC_URI="https://sourceware.org/pub/docbook-tools/new-trials/SOURCES/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="jadetex"

DEPEND=">=dev-lang/perl-5
	app-text/docbook-dsssl-stylesheets
	app-text/docbook-xml-dtd:4.2
	app-text/openjade
	app-text/xhtml1
	dev-perl/SGMLSpm
	~app-text/docbook-sgml-dtd-3.0
	~app-text/docbook-sgml-dtd-3.1
	~app-text/docbook-sgml-dtd-4.0
	~app-text/docbook-sgml-dtd-4.1
	~app-text/docbook-sgml-dtd-4.2
	~app-text/docbook-sgml-dtd-4.4
	~app-text/docbook-xml-simple-dtd-1.0
	~app-text/docbook-xml-simple-dtd-4.1.2.4
	jadetex? ( dev-texlive/texlive-formatsextra )
	|| (
		www-client/lynx
		www-client/links
		www-client/elinks
		virtual/w3m
	)"
RDEPEND="${DEPEND}"

# including both xml-simple-dtd 4.1.2.4 and 1.0, to ease
# transition to simple-dtd 1.0, <obz@gentoo.org>

PATCHES=(
	"${FILESDIR}"/${MY_P}-elinks.patch
	"${FILESDIR}"/${P}-grep-2.7.patch

	# drop dependency on sys-apps/which
	"${FILESDIR}"/0001-Migrate-from-1998-style-which-progname-lookup-to-com.patch
)

src_prepare() {
	default
	if use prefix; then
		eapply "${FILESDIR}"/${MY_P}-prefix.patch
		eprefixify doc/{man,HTML}/Makefile.am bin/jw.in backends/txt configure.in
		eautoreconf
	fi
}

src_install() {
	make DESTDIR="${D}" \
		htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		install

	if ! use jadetex; then
		local i
		for i in dvi pdf ps; do
			rm "${ED}"/usr/bin/docbook2${i} || die
			rm "${ED}"/usr/share/sgml/docbook/utils-${PV}/backends/${i} || die
			rm "${ED}"/usr/share/man/man1/docbook2${i}.1 || die
		done
	fi
	einstalldocs
}
