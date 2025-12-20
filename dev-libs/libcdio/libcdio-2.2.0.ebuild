# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic libtool multilib-minimal

DESCRIPTION="A library to encapsulate CD-ROM reading and control"
HOMEPAGE="https://www.gnu.org/software/libcdio/"
SRC_URI="https://github.com/libcdio/libcdio/releases/download/${PV}/${P}.tar.bz2"

LICENSE="FDL-1.2+ GPL-2+ GPL-3+ LGPL-2.1+"
SLOT="0/19" # subslot is based on SONAME
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"
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

DOCS=( AUTHORS ChangeLog NEWS.md README{,-libcdio}.md THANKS )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/cdio/cdio_config.h
	/usr/include/cdio/version.h
)

PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-ncurses_pkgconfig.patch"
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

	# Needed for fseeko64 on 32-bit builds
	append-lfs-flags

	local util_switch="--with"
	if ! multilib_is_native_abi || use minimal ; then
		util_switch="--without"
	fi

	local myeconfargs=(
		--disable-maintainer-mode
		--disable-cpp-progs
		--disable-example-progs
		--disable-vcd-info
		$(use_enable cddb)
		$(use_enable cxx)
		$(use_enable static-libs static)
		${util_switch}-{cd-drive,cd-info,cdda-player,cd-read,iso-info,iso-read}
	)
	# Tests fail if ECONF_SOURCE is not relative
	ECONF_SOURCE="../${P}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
