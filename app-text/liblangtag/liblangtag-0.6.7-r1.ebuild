# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Interface library to access tags for identifying languages"
HOMEPAGE="https://bitbucket.org/tagoh/liblangtag"
SRC_URI="https://bitbucket.org/tagoh/${PN}/downloads/${P}.tar.bz2"

LICENSE="|| ( LGPL-3 MPL-2.0 )"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv x86"
IUSE="debug doc introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2:=
	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )
"
BDEPEND="
	sys-devel/gettext
	dev-build/libtool
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection-common )
"

src_prepare() {
	default
	xdg_environment_reset
	if [[ -d docs/html ]]; then
		rm -r docs/html || die "Failed to remove existing gtk-doc"
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable doc gtk-doc)
		$(use_enable introspection)
		$(use_enable test)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
