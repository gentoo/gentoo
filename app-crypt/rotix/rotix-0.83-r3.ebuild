# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Rotix allows you to generate rotational obfuscations"
HOMEPAGE="https://github.com/shemminga/rotix"
SRC_URI="https://github.com/shemminga/${PN}/releases/download/${PV}/${PN}_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="nls"

BDEPEND="nls? ( sys-devel/gettext )"
RDEPEND="nls? ( virtual/libintl )"

PATCHES=(
	"${FILESDIR}/rotix-0.83-meson-build.patch"
	"${FILESDIR}/rotix-0.83-locale.patch"
	"${FILESDIR}/rotix-0.83-interix.patch"
	"${FILESDIR}/rotix-0.83-nl.po-charset.patch"
)

DOCS=(
	README
)

src_prepare() {
	default
	mv po/{NL,nl}.po || die
}

src_configure() {
	local emesonargs=(
		$(meson_use nls i18n)
	)
	meson_src_configure
}
