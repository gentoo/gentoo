# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs multilib flag-o-matic usr-ldscript

DESCRIPTION="Light-weight 'standard library' of C functions"
HOMEPAGE="https://launchpad.net/libnih"
SRC_URI="https://launchpad.net/${PN}/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 ~sparc ~x86"
IUSE="+dbus nls static-libs +threads"

# The configure phase will check for valgrind headers, and the tests will use
# that header, but only to do dynamic valgrind detection.  The tests aren't
# run directly through valgrind, only by developers directly.  So don't bother
# depending on valgrind here. #559830
RDEPEND="dbus? ( dev-libs/expat >=sys-apps/dbus-1.2.16 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"
PATCHES=(
	"${FILESDIR}"/${P}-optional-dbus.patch
	"${FILESDIR}"/${P}-pkg-config.patch
	"${FILESDIR}"/${P}-signal-race.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-expat-2.2.5.patch
	"${FILESDIR}"/${P}-glibc-2.24.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-lfs-flags
	econf \
		$(use_with dbus) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable threads) \
		$(use_enable threads threading)
}

src_install() {
	default

	# we need to be in / because upstart needs libnih
	gen_usr_ldscript -a nih $(use dbus && echo nih-dbus)
	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.la
}
