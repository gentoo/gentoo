# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils mono-env versionator

DIR_PV=$(get_version_component_range 1-2)
DIR_PV2=$(get_version_component_range 1-3)

DESCRIPTION="Mono DBus API wrapper for Zeitgeist"
HOMEPAGE="https://launchpad.net/zeitgeist-sharp/"
SRC_URI="
	https://launchpad.net/zeitgeist-sharp/${DIR_PV}/${DIR_PV2}/+download/${P}.tar.gz
	doc? ( https://launchpad.net/zeitgeist-sharp/${DIR_PV}/${DIR_PV2}/+download/${PN}-docs-${DIR_PV2}.tar.gz )"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"
IUSE="doc"

RDEPEND="
	dev-dotnet/dbus-sharp:1.0
	dev-dotnet/dbus-sharp-glib:1.0
	dev-dotnet/glib-sharp
	dev-lang/mono
	gnome-extra/zeitgeist"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/${P}-zg-0.9.patch
	"${FILESDIR}"/${P}-automake-1.12.patch
	"${FILESDIR}"/${P}-fix-tools-version.patch
)

src_prepare() {
	sed \
		-e "s:@expanded_libdir@:@libdir@:" \
		-i Zeitgeist/zeitgeist-sharp.pc.in || die
	autotools-utils_src_prepare
}

src_install() {
	use doc && HTML_DOCS=( "${WORKDIR}"/${PN}-docs/. )
	autotools-utils_src_install
}
