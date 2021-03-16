# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# XXX: atm, libbz2.a is always PIC :(, so it is always built quickly
#      (since we're building shared libs) ...

EAPI=7

inherit toolchain-funcs multilib-minimal usr-ldscript

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="https://sourceware.org/bzip2/"
SRC_URI="https://sourceware.org/pub/${PN}/${P}.tar.gz"

LICENSE="BZIP2"
SLOT="0/1" # subslot = SONAME
KEYWORDS="~alpha ~amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="static static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.4-makefile-CFLAGS.patch
	"${FILESDIR}"/${PN}-1.0.8-saneso.patch
	"${FILESDIR}"/${PN}-1.0.4-man-links.patch #172986
	"${FILESDIR}"/${PN}-1.0.6-progress.patch
	"${FILESDIR}"/${PN}-1.0.3-no-test.patch
	"${FILESDIR}"/${PN}-1.0.8-mingw.patch #393573
	"${FILESDIR}"/${PN}-1.0.8-out-of-tree-build.patch
)

DOCS=( CHANGES README{,.COMPILATION.PROBLEMS,.XML.STUFF} manual.pdf )
HTML_DOCS=( manual.html )

src_prepare() {
	default

	# - Use right man path
	# - Generate symlinks instead of hardlinks
	# - pass custom variables to control libdir
	sed -i \
		-e 's:\$(PREFIX)/man:\$(PREFIX)/share/man:g' \
		-e 's:ln -s -f $(PREFIX)/bin/:ln -s -f :' \
		-e 's:$(PREFIX)/lib:$(PREFIX)/$(LIBDIR):g' \
		Makefile || die
}

bemake() {
	emake \
		VPATH="${S}" \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		"$@"
}

multilib_src_compile() {
	bemake -f "${S}"/Makefile-libbz2_so all
	# Make sure we link against the shared lib #504648
	ln -s libbz2.so.${PV} libbz2.so || die
	bemake -f "${S}"/Makefile all LDFLAGS="${LDFLAGS} $(usex static -static '')"
}

multilib_src_install() {
	into /usr

	# Install the shared lib manually.  We install:
	#  .x.x.x - standard shared lib behavior
	#  .x.x   - SONAME some distros use #338321
	#  .x     - SONAME Gentoo uses
	dolib.so libbz2.so.${PV}
	local v
	for v in libbz2.so{,.{${PV%%.*},${PV%.*}}} ; do
		dosym libbz2.so.${PV} /usr/$(get_libdir)/${v}
	done

	# Install libbz2.so.1.0 due to accidental soname change in 1.0.7.
	# Reference: 98da0ad82192d21ad74ae52366ea8466e2acea24.
	# OK to remove one year after 2020-04-11.
	if [[ ! -L "${ED}/usr/$(get_libdir)/libbz2.so.1.0" ]]; then
		dosym libbz2.so.${PV} "/usr/$(get_libdir)/libbz2.so.1.0"
	fi

	use static-libs && dolib.a libbz2.a

	if multilib_is_native_abi ; then
		gen_usr_ldscript -a bz2

		dobin bzip2recover
		into /
		dobin bzip2
	fi
}

multilib_src_install_all() {
	# `make install` doesn't cope with out-of-tree builds, nor with
	# installing just non-binaries, so handle things ourselves.
	insinto /usr/include
	doins bzlib.h
	into /usr
	dobin bz{diff,grep,more}
	doman *.1

	dosym bzdiff /usr/bin/bzcmp
	dosym bzdiff.1 /usr/share/man/man1/bzcmp.1

	dosym bzmore /usr/bin/bzless
	dosym bzmore.1 /usr/share/man/man1/bzless.1

	local x
	for x in bunzip2 bzcat bzip2recover ; do
		dosym bzip2.1 /usr/share/man/man1/${x}.1
	done
	for x in bz{e,f}grep ; do
		dosym bzgrep /usr/bin/${x}
		dosym bzgrep.1 /usr/share/man/man1/${x}.1
	done

	einstalldocs

	# move "important" bzip2 binaries to /bin and use the shared libbz2.so
	dosym bzip2 /bin/bzcat
	dosym bzip2 /bin/bunzip2
}
