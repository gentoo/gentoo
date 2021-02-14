# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit meson gnome2

DESCRIPTION="GTK# Hex Editor"
HOMEPAGE="https://github.com/afrantzis/Bless/"
SRC_URI="https://github.com/afrantzis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# EGIT_REPO_URI="https://github.com/afrantzis/bless/"
# EGIT_COMMIT="v${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"

RDEPEND="
	>=dev-util/meson-0.46
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

src_configure() {
	local emesonargs=(
		$(meson_use test tests)
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
