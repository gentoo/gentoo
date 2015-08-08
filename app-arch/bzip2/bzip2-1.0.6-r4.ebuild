# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# XXX: atm, libbz2.a is always PIC :(, so it is always built quickly
#      (since we're building shared libs) ...

EAPI=4

inherit eutils toolchain-funcs multilib multilib-minimal

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="http://www.bzip.org/"
SRC_URI="http://www.bzip.org/${PV}/${P}.tar.gz"

LICENSE="BZIP2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="static static-libs"

RDEPEND="abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.4-makefile-CFLAGS.patch
	epatch "${FILESDIR}"/${PN}-1.0.6-saneso.patch
	epatch "${FILESDIR}"/${PN}-1.0.4-man-links.patch #172986
	epatch "${FILESDIR}"/${PN}-1.0.6-progress.patch
	epatch "${FILESDIR}"/${PN}-1.0.3-no-test.patch
	epatch "${FILESDIR}"/${PN}-1.0.4-POSIX-shell.patch #193365
	epatch "${FILESDIR}"/${PN}-1.0.6-mingw.patch #393573

	# - Use right man path
	# - Generate symlinks instead of hardlinks
	# - pass custom variables to control libdir
	sed -i \
		-e 's:\$(PREFIX)/man:\$(PREFIX)/share/man:g' \
		-e 's:ln -s -f $(PREFIX)/bin/:ln -s -f :' \
		-e 's:$(PREFIX)/lib:$(PREFIX)/$(LIBDIR):g' \
		Makefile || die

	multilib_copy_sources
}

bemake() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		"$@"
}

multilib_src_compile() {
	bemake -f Makefile-libbz2_so all
	bemake all LDFLAGS="${LDFLAGS} $(usex static -static '')"
}

multilib_src_install() {
	emake PREFIX="${ED}"/usr LIBDIR=$(get_libdir) install

	# Install the shared lib manually.  We install:
	#  .x.x.x - standard shared lib behavior
	#  .x.x   - SONAME some distros use #338321
	#  .x     - SONAME Gentoo uses
	dolib.so libbz2.so.${PV}
	local v
	for v in libbz2.so{,.{${PV%%.*},${PV%.*}}} ; do
		dosym libbz2.so.${PV} /usr/$(get_libdir)/${v}
	done
	gen_usr_ldscript -a bz2

	use static || newbin bzip2-shared bzip2
}

multilib_src_install_all() {
	dodoc README* CHANGES bzip2.txt manual.*

	# move "important" bzip2 binaries to /bin and use the shared libbz2.so
	dodir /bin
	mv "${ED}"/usr/bin/b{zip2,zcat,unzip2} "${ED}"/bin/ || die
	dosym bzip2 /bin/bzcat
	dosym bzip2 /bin/bunzip2

	use static-libs || find "${ED}"/usr -name libbz2.a -delete
}
