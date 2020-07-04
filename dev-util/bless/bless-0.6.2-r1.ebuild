# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2 mono-env

DESCRIPTION="GTK# Hex Editor"
HOMEPAGE="https://github.com/afrantzis/Bless/"
SRC_URI="https://github.com/afrantzis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# EGIT_REPO_URI="https://github.com/afrantzis/bless/"
# EGIT_COMMIT="v${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	>=dev-lang/mono-1.1.14
	>=dev-dotnet/gtk-sharp-2.12.21:2
"
DEPEND="${RDEPEND}
	app-text/rarian
	>=sys-devel/gettext-0.15
	virtual/pkgconfig
"

# See bug 278162
# Waiting on nunit ebuild entering the tree
RESTRICT="test"

pkg_setup() {
	mono-env_pkg_setup
}

src_prepare() {
	eautoreconf
	# The autoreconf expects INSTALL to have been copied over by autoconf
	touch "${S}/INSTALL"
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-unix-specific \
		$(use_enable debug)
}

src_install() {
	default

	mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${P}" || die "Unable to make documentation version-specific."
}
