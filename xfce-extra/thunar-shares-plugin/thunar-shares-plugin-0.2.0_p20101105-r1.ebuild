# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Thunar plugin to share files using Samba"
HOMEPAGE="https://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.18
	>=x11-libs/gtk+-2.12:2
	<xfce-base/thunar-1.7"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/xfce4-dev-tools
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		--disable-static
		# workaround the default for git builds
		--enable-debug=minimal
	)
	econf "${myconf[@]}"
}

src_prepare() {
	default
	mv configure.in configure.ac || die
	# https://bugzilla.xfce.org/show_bug.cgi?id=10032
	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:-Werror::' \
		configure.ac || die

	local AT_M4DIR="${EPREFIX}/usr/share/xfce4/dev-tools/m4macros"
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
