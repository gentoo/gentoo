# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic libtool multilib-minimal

DESCRIPTION="A library to encapsulate CD-ROM reading and control"
HOMEPAGE="https://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0/19" # subslot is based on SONAME
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="cddb +cxx minimal static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		>=sys-libs/ncurses-5.7-r7:0=
		cddb? ( >=media-libs/libcddb-1.3.2 )
	)
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-lang/perl )
"

DOCS=( AUTHORS ChangeLog NEWS.md README{,.libcdio} THANKS TODO )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/cdio/cdio_config.h
	/usr/include/cdio/version.h
)

PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-ncurses_pkgconfig.patch"
	"${FILESDIR}/${P}-realpath-test-fix.patch"
	"${FILESDIR}/${P}-no-lfs-shims.patch"
)

src_prepare() {
	default

	eautoreconf
	elibtoolize # to prevent -L/usr/lib ending up in the linker line wrt #499510
}

multilib_src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/855701
	# https://savannah.gnu.org/bugs/index.php?65458
	filter-lto

	# Workaround for LLD 17, drop after 2.1.0 (bug #915826)
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	local util_switch
	if ! multilib_is_native_abi || use minimal ; then
		util_switch="--without"
	else
		util_switch="--with"
	fi

	local myeconfargs=(
		--disable-maintainer-mode
		$(use_enable cxx)
		--disable-cpp-progs
		--disable-example-progs
		$(use_enable static-libs static)
		$(use_enable cddb)
		--disable-vcd-info
		${util_switch}-{cd-drive,cd-info,cdda-player,cd-read,iso-info,iso-read}
	)
	# Tests fail if ECONF_SOURCE is not relative
	ECONF_SOURCE="../${P}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
