# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson virtualx

DESCRIPTION="UI library that focuses on simplicity and minimalism"
HOMEPAGE="https://pwmt.org/projects/girara/"
SRC_URI="https://pwmt.org/projects/girara/download/${P}.tar.xz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc libnotify test"

RDEPEND="dev-libs/glib:2
	 dev-libs/json-c
	 >=x11-libs/gtk+-3.20:3
	 >=x11-libs/pango-1.14
	 libnotify? ( x11-libs/libnotify )"

DEPEND="${RDEPEND}
	 doc? ( app-doc/doxygen )
	 test? ( dev-libs/check )"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i -e '/'-Werror.*'/d' meson.build || die "sed failed"
}

src_configure() {
	local emesonargs=(
		--libdir=/usr/$(get_libdir)
		-Denable-json=true
		-Denable-docs=$(usex doc true false)
		-Denable-notify=$(usex libnotify true false)
		)
		meson_src_configure
}

src_test() {
	virtx default
}
