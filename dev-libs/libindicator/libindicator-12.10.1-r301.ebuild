# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils flag-o-matic virtualx multilib-minimal

DESCRIPTION="A set of symbols and convience functions that all indicators would like to use"
HOMEPAGE="https://launchpad.net/libindicator"
SRC_URI="https://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/glib-2.22[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.2:3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	test? ( dev-util/dbus-test-runner )"

src_prepare() {
	# https://bugs.launchpad.net/libindicator/+bug/1502925
	epatch "${FILESDIR}"/${PN}-ldflags-spacing.patch
	eautoreconf
}

multilib_src_configure() {
	append-flags -Wno-error

	myconf=(
		--disable-silent-rules
		--disable-static
		--with-gtk=3
	)
	local ECONF_SOURCE=${S}
	econf "${myconf[@]}"
}

multilib_src_test() {
	Xemake check #391179
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all
}
