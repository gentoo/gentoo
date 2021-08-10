# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Main event loop abstraction library"
HOMEPAGE="https://github.com/latchset/libverto/"
SRC_URI="https://github.com/latchset/libverto/releases/download/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="glib +libev libevent +threads"
REQUIRED_USE="|| ( glib libev libevent )"

DEPEND="glib? ( >=dev-libs/glib-2.34.3[${MULTILIB_USEDEP}] )
	libev? ( >=dev-libs/libev-4.15[${MULTILIB_USEDEP}] )
	libevent? ( >=dev-libs/libevent-2.0.21[${MULTILIB_USEDEP}] )"

RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS INSTALL README )

PATCHES=(
	"${FILESDIR}"/${P}-non-bash.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		$(use_with glib) \
		$(use_with libev) \
		$(use_with libevent) \
		$(use_with threads pthread) \
		--disable-static
}

multilib_src_install_all() {
	default

	find "${ED}" -name '*.la' -delete || die
}
