# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic virtualx multilib-minimal

DESCRIPTION="A set of symbols and convience functions that all indicators would like to use"
HOMEPAGE="https://launchpad.net/libindicator"
SRC_URI="https://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.22[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.2:3[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	test? ( dev-util/dbus-test-runner )"

PATCHES=(
	# Fixed version of https://bugs.launchpad.net/libindicator/+bug/1502925
	"${FILESDIR}"/${PN}-12.10.1-r301-nonbash.patch
)

src_prepare() {
	default

	eautoreconf
}

multilib_src_configure() {
	append-flags -Wno-error

	local myconf=(
		--disable-static
		--with-gtk=3
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_test() {
	# bug #391179
	Xemake check
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	default

	find "${ED}" -name '*.la' -delete || die
}
