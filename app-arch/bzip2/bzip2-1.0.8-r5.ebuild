# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# XXX: atm, libbz2.a is always PIC :(, so it is always built quickly
#      (since we're building shared libs) ...

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/bzip2.gpg
inherit toolchain-funcs multilib multilib-minimal verify-sig

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="https://sourceware.org/bzip2/"
SRC_URI="https://sourceware.org/pub/${PN}/${P}.tar.gz"
SRC_URI+=" verify-sig? ( https://sourceware.org/pub/${PN}/${P}.tar.gz.sig )"

LICENSE="BZIP2"
SLOT="0/1" # subslot = SONAME
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos"
IUSE="static static-libs"

BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-bzip2 )
"
PDEPEND="
	app-alternatives/bzip2
"

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

multilib_src_test() {
	cp "${S}"/sample* "${BUILD_DIR}" || die
	bemake -f "${S}"/Makefile check
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

	use static-libs && dolib.a libbz2.a

	if multilib_is_native_abi ; then
		dobin bzip2recover$(get_exeext)
		into /
		newbin bzip2$(get_exeext) bzip2-reference$(get_exeext)
	fi
}

multilib_src_install_all() {
	# `make install` doesn't cope with out-of-tree builds, nor with
	# installing just non-binaries, so handle things ourselves.
	insinto /usr/include
	doins bzlib.h
	into /usr
	dobin bz{diff,grep,more}
	doman bz{diff,grep,more}.1
	newman bzip2.1 bzip2-reference.1

	dosym bzdiff /usr/bin/bzcmp
	dosym bzdiff.1 /usr/share/man/man1/bzcmp.1

	dosym bzmore /usr/bin/bzless
	dosym bzmore.1 /usr/share/man/man1/bzless.1

	dosym bzip2-reference.1 /usr/share/man/man1/bzip2recover.1
	local x
	for x in bz{e,f}grep ; do
		dosym bzgrep /usr/bin/${x}
		dosym bzgrep.1 /usr/share/man/man1/${x}.1
	done

	einstalldocs
}

pkg_postinst() {
	# ensure to preserve the symlinks before app-alternatives/bzip2
	# is installed
	local x
	for x in bzip2 bunzip2 bzcat; do
		if [[ ! -h ${EROOT}/bin/${x} ]]; then
			ln -s bzip2-reference$(get_exeext) "${EROOT}/bin/${x}$(get_exeext)" || die
		fi
	done
}
