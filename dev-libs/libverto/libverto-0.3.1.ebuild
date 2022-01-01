# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Main event loop abstraction library"
HOMEPAGE="https://github.com/latchset/libverto/"
SRC_URI="https://github.com/latchset/libverto/releases/download/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"
IUSE="glib +libev libevent tevent +threads static-libs"

DEPEND="glib? ( >=dev-libs/glib-2.34.3[${MULTILIB_USEDEP}] )
	libev? ( >=dev-libs/libev-4.15[${MULTILIB_USEDEP}] )
	libevent? ( >=dev-libs/libevent-2.0.21[${MULTILIB_USEDEP}] )
	tevent? ( >=sys-libs/tevent-0.9.19[${MULTILIB_USEDEP}] )"

RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( glib libev libevent tevent ) "

DOCS=( AUTHORS ChangeLog NEWS INSTALL README )

src_prepare() {
	default
	# known problem uptream with tevent write test.  tevent does not fire a
	# callback on error, but we explicitly test for this behaviour.  Do not run
	# tevent tests for now.
	sed -i -e 's/def HAVE_TEVENT/ 0/' tests/test.h || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		$(use_with glib) \
		$(use_with libev) \
		$(use_with libevent) \
		$(use_with tevent) \
		$(use_with threads pthread) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
