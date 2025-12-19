# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="a portable, high level programming interface to various calling conventions"
HOMEPAGE="https://sourceware.org/libffi/"
SRC_URI="https://github.com/libffi/libffi/releases/download/v${PV}/libffi-${PV}.tar.gz"

LICENSE="MIT"
SLOT="7" # SONAME=libffi.so.7
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="debug pax-kernel test"

RESTRICT="!test? ( test )"

RDEPEND="!dev-libs/libffi:0/7" # conflicts on libffi.so.7
DEPEND=""
BDEPEND="test? ( dev-util/dejagnu )"

DOCS="ChangeLog* README.md"

PATCHES=(
	"${FILESDIR}"/libffi-3.2.1-o-tmpfile-eacces.patch #529044
	"${FILESDIR}"/libffi-3.3_rc0-ppc-macos-go.patch
	"${FILESDIR}"/libffi-3.3-power7.patch
	"${FILESDIR}"/libffi-3.3-power7-memcpy.patch
	"${FILESDIR}"/libffi-3.3-power7-memcpy-2.patch
	"${FILESDIR}"/libffi-3.3-ppc-int128.patch
	"${FILESDIR}"/libffi-3.3-ppc-vector-offset.patch
	"${FILESDIR}"/libffi-3.3-compiler-vendor-quote.patch
)

S=${WORKDIR}/libffi-${PV}

ECONF_SOURCE=${S}

src_prepare() {
	default
	if [[ ${CHOST} == arm64-*-darwin* ]] ; then
		# ensure we use aarch64 asm, not x86 on arm64
		sed -i -e 's/aarch64\*-\*-\*/arm64*-*-*|&/' \
			configure configure.host || die
	fi
}

multilib_src_configure() {
	# --includedir= path maintains a few properties:
	# 1. have stable name across libffi versions: some packages like
	#    dev-lang/ghc or kde-frameworks/networkmanager-qt embed
	#    ${includedir} at build-time. Don't require those to be
	#    rebuilt unless SONAME changes. bug #695788
	#
	#    We use /usr/.../${PN} (instead of former /usr/.../${P}).
	#
	# 2. have ${ABI}-specific location as ffi.h is target-dependent.
	#
	#    We use /usr/$(get_libdir)/... to have ABI identifier.
	econf \
		--includedir="${EPREFIX}"/usr/$(get_libdir)/${PN}/include \
		--disable-multi-os-directory \
		--disable-static \
		$(use_enable pax-kernel pax_emutramp) \
		$(use_enable debug)
}

multilib_src_install() {
	dolib.so .libs/libffi.so.${SLOT}*
}
