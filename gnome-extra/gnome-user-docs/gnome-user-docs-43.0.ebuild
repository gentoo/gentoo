# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2

DESCRIPTION="GNOME end user documentation"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-user-docs"

LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

BDEPEND="test? ( dev-libs/libxml2 )"
# eautoreconf requires:
#	app-text/yelp-tools
# rebuilding translations requires:
#	app-text/yelp-tools
#	dev-util/gettext

# This ebuild does not install any binaries
RESTRICT="binchecks strip
	!test? ( test )"

src_configure() {
	# itstool is only needed for rebuilding translations
	# xmllint is only needed for tests
	gnome2_src_configure \
		$(usex test "" XMLLINT=$(type -P true)) \
		ITSTOOL=$(type -P true)
}

src_compile() {
	# Do not compile; "make all" with unset LINGUAS rebuilds all translations,
	# which can take > 2 hours on a Core i7.
	return
}
