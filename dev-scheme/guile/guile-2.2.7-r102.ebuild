# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GNU Ubiquitous Intelligent Language for Extensions"
HOMEPAGE="https://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="$(ver_cut 1-2)"  # See (guile)Parallel Installations.
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug debug-malloc +deprecated +networking +nls +regex +threads" # upstream recommended +networking +nls
REQUIRED_USE="regex" # workaround for bug 596322
RESTRICT="strip"

RDEPEND="
	>=dev-libs/boehm-gc-7.0:=[threads?]
	dev-libs/gmp:=
	dev-libs/libffi:=
	dev-libs/libltdl:=
	dev-libs/libunistring:0=
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	virtual/libcrypt:=
	!dev-scheme/guile:12
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-build/libtool
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.3-gentoo-sandbox.patch"
	"${FILESDIR}/${PN}-2.2.7-stack-up.patch"
)

# guile generates ELF files without use of C or machine code
# It's a portage's false positive. bug #677600
QA_PREBUILT='*[.]go'

GUILE_INFODIR="${EPREFIX}"/usr/share/guile-data/"${SLOT}"/info

DOCS=( GUILE-VERSION HACKING README )

src_configure() {
	# see bug #676468
	mv prebuilt/32-bit-big-endian{,.broken} || die

	econf \
		--infodir="${GUILE_INFODIR}" \
		--program-suffix="-${SLOT}" \
		--disable-error-on-warning \
		--disable-rpath \
		--disable-static \
		--enable-posix \
		--without-libgmp-prefix \
		--without-libiconv-prefix \
		--without-libintl-prefix \
		--without-libltdl-prefix \
		--without-libreadline-prefix \
		--without-libunistring-prefix \
		$(use_enable debug guile-debug) \
		$(use_enable debug-malloc) \
		$(use_enable deprecated) \
		$(use_enable networking) \
		$(use_enable nls) \
		$(use_enable regex) \
		$(use_with threads)
}

# Akin to (and taken from) toolchain-autoconfs eclass
guile_slot_info() {
	rm -f dir || die

	pushd "${D}/${GUILE_INFODIR}" >/dev/null || die
	for f in *.info*; do
		# Install convenience aliases for versioned Guile pages.
		ln -s "$f" "${f/./-${SLOT}.}" || die
	done
	popd >/dev/null || die

	docompress "${GUILE_INFODIR}"
}

src_install() {
	default

	# From Novell
	# https://bugzilla.novell.com/show_bug.cgi?id=874028#c0
	dodir /usr/share/gdb/auto-load/$(get_libdir)
	mv "${ED}"/usr/$(get_libdir)/libguile-*-gdb.scm "${ED}"/usr/share/gdb/auto-load/$(get_libdir) || die

	find "${D}" -name '*.la' -delete || die

	# Move the pkg-config files to guile-data.  In future versions, this
	# should be handled by --with-pkgconfigdir (patch waiting on
	# upstream).
	local datadir=/usr/share/guile-data/"${SLOT}"
	local pcdir="${datadir}"/pkgconfig
	mkdir -p "${ED}${datadir}" || die
	mv "${ED}"/usr/share/aclocal/guile{,-"${SLOT}"}.m4 || die
	mv "${ED}"/usr/$(get_libdir)/pkgconfig/ \
	   "${ED}/${pcdir}" || die

	guile_slot_info

	local major="$(ver_cut 1 "${SLOT}")"
	local minor="$(ver_cut 2 "${SLOT}")"
	local idx="$((99999-(major*1000+minor)))"
	newenvd - "50guile${idx}" <<-EOF
	PKG_CONFIG_PATH="${pcdir}"
	INFOPATH="${GUILE_INFODIR}"
	EOF
}
