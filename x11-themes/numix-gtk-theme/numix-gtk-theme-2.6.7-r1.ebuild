# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

inherit ruby-ng

DESCRIPTION="A modern flat theme with a combination of light and dark elements"
HOMEPAGE="https://github.com/numixproject/numix-gtk-theme"
SRC_URI="https://github.com/numixproject/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libxml2:2
	x11-libs/gtk+:3
	x11-themes/gtk-engines-murrine"

DEPEND="${RDEPEND}
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2"

ruby_add_depend ">=dev-ruby/sass-3.5"

S="${WORKDIR}/${P}"

src_unpack() {
	default
}

src_prepare() {
	default
}

src_compile() {
	default
}

src_install() {
	default
}
