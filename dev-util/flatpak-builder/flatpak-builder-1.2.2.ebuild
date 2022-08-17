# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

SRC_URI="https://github.com/flatpak/${PN}/releases/download/${PV}/${P}.tar.xz"
DESCRIPTION="Tool to build flatpaks from source"
HOMEPAGE="http://flatpak.org/"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="doc +yaml"

RDEPEND="
	>=sys-apps/flatpak-0.99.1
	>=dev-util/ostree-2019.5:=
	>=net-libs/libsoup-2.4:=
	>=dev-libs/elfutils-0.8.12:=
	>=dev-libs/glib-2.44:2=
	>=dev-libs/libxml2-2.4:=
	dev-libs/json-glib:=
	net-misc/curl:=
	yaml? ( dev-libs/libyaml:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.18.2
	virtual/pkgconfig
	doc? (
		app-text/xmlto
		dev-libs/libxslt
	)
"

PATCHES=("${FILESDIR}/flatpak-builder-1.2.2-musl.patch")

src_configure() {
	econf \
		$(use_enable doc documentation) \
		$(use_enable doc docbook-docs) \
		$(use_with yaml)
}
