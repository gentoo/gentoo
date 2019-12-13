# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator toolchain-funcs

MY_PV=$(replace_version_separator 2 '_')

DESCRIPTION="A vi/ex clone"
HOMEPAGE="http://elvis.the-little-red-haired-girl.org"
SRC_URI="ftp://ftp.cs.pdx.edu/pub/elvis/${PN}-${MY_PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~ppc-macos ~x86-macos ~m68k-mint ~sparc-solaris"
IUSE="X doc"

RDEPEND="
	sys-libs/ncurses:0=
	app-eselect/eselect-vi
	X? (
		>=x11-libs/libX11-1.0.0
		>=x11-libs/libXt-1.0.0
		>=x11-libs/libXpm-3.5.4.2
		>=x11-libs/libXft-2.1.8.2
	)"

DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}"/ft2.3-symbol-collision-fix.patch
	"${FILESDIR}"/${P}-glibc-2.10.patch
	"${FILESDIR}"/${P}-interix.patch
)

src_configure() {
	./configure \
		--libs="$($(tc-getPKG_CONFIG) --libs ncurses)" \
		--prefix="${EPREFIX}"/usr \
		--bindir="${EPREFIX}"/usr/bin \
		--datadir="${EPREFIX}"/usr/share/elvis \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_with X x) \
		|| die

	# Some Makefile fixups (must happen after configure)
	# Use our CFLAGS
	sed -i -e "s:gcc -O2:$(tc-getCC) ${CFLAGS}:" Makefile || die "sed 1 failed"

	# We'll install the man-pages ourselves
	sed -i -e '/^	sh instman.sh/d' Makefile || die "sed 2 failed"

	# Don't try to write to /etc
	sed -i -e 's,/etc/elvis,${ED}/etc/elvis,g' Makefile || die "sed 3 failed"

	# Use LDFLAGS
	sed -i -e "s#\$(CC) \$(CFLAGS)#\$(CC) \$(CFLAGS) ${LDFLAGS}#" Makefile || \
		die "sed 4 failed"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	dodir /usr/share/elvis
	dodir /usr/share/doc/${PF}
	dodir /etc

	local docdir="${ED}/usr/share/doc/${PF}"
	if ! use doc; then
		docdir="${T}/doc-discard"
	fi

	emake install \
		PREFIX="${ED}"/usr \
		BINDIR="${ED}"/usr/bin \
		DATADIR="${ED}"/usr/share/elvis \
		DOCDIR="${docdir}"

	# Install the man-pages
	mv doc/elvis.man doc/elvis.1 || die
	mv doc/elvtags.man doc/elvtags.1 || die
	mv doc/ref.man doc/ref.1 || die
	doman doc/*.1

	# Fixup some READMEs
	sed -i -e "s,${ED},,g" "${ED}"/etc/elvis/README \
		|| die 'sed /etc/elvis/README failed'
	sed -i -e "s,${ED},,g" "${ED}"/usr/share/elvis/README \
		|| die 'sed /usr/share/elvis/README failed'
}

pkg_postinst() {
	einfo "Setting /usr/bin/vi symlink"
	eselect vi set "${PN}"
}

pkg_postrm() {
	einfo "Updating /usr/bin/vi symlink"
	eselect vi update
}
