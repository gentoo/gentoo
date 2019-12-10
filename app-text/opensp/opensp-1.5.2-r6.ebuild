# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic autotools

MY_P=${P/opensp/OpenSP}

DESCRIPTION="A free, object-oriented toolkit for SGML parsing and entity management"
HOMEPAGE="http://openjade.sourceforge.net/"
SRC_URI="mirror://sourceforge/openjade/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc elibc_glibc nls static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	elibc_glibc? ( net-libs/libnsl:0= )
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	doc? (
		app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2
	)
	test? (
		app-text/docbook-xml-dtd:4.5
		app-text/openjade
		app-text/sgml-common
	)"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-segfault.patch
	epatch "${FILESDIR}"/${P}-c11-using.patch
	use prefix && eautoreconf
}

src_configure() {
	export CONFIG_SHELL=${BASH}  # configure needs bash

	# The following filters are taken from openjade's ebuild. See bug #100828.
	# Please note!  Opts are disabled.  If you know what you're doing
	# feel free to remove this line.  It may cause problems with
	# docbook-sgml-utils among other things.
	#ALLOWED_FLAGS="-O -O1 -O2 -pipe -g -march"
	strip-flags

	econf \
		--enable-http \
		--enable-default-catalog="${EPREFIX}"/etc/sgml/catalog \
		--enable-default-search-path="${EPREFIX}"/usr/share/sgml \
		--datadir="${EPREFIX}"/usr/share/sgml/${P} \
		$(use_enable nls) \
		$(use_enable doc doc-build) \
		$(use_enable static-libs static)
}

src_compile() {
	emake pkgdocdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_test() {
	# Skipping tests known not to work
	emake SHOWSTOPPERS= check
	SANDBOX_PREDICT="${SANDBOX_PREDICT%:/}"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		pkgdocdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	prune_libtool_files

	dodoc AUTHORS BUGS ChangeLog NEWS README
}
