# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Run cargo-build or cargo fetch in lib/mp4 to get this list
CRATES="
ahash-0.7.6
aho-corasick-0.7.18
atty-0.2.14
autocfg-1.0.0
bitreader-0.3.2
byteorder-1.2.2
cfg-if-0.1.10
cfg-if-1.0.0
env_logger-0.8.4
fallible_collections-0.4.4
getrandom-0.2.7
hashbrown-0.11.2
hermit-abi-0.1.8
humantime-2.1.0
libc-0.2.126
log-0.4.17
memchr-2.5.0
num-traits-0.2.15
once_cell-1.12.0
regex-1.5.6
regex-syntax-0.6.26
static_assertions-1.1.0
termcolor-1.1.3
version_check-0.9.4
wasi-0.11.0+wasi-snapshot-preview1
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo gnome2-utils

DESCRIPTION="RAW image formats decoding library"
HOMEPAGE="https://libopenraw.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/download/${P}.tar.xz"
SRC_URI+=" $(cargo_crate_uris)"

LICENSE="GPL-3 LGPL-3"
SLOT="0/9"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="gtk test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2
	media-libs/libjpeg-turbo:=
	gtk? (
		dev-libs/glib:2
		>=x11-libs/gdk-pixbuf-2.24.0:2
	)
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	virtual/pkgconfig
	test? ( net-misc/curl )
"

src_configure() {
	econf \
		--with-boost="${EPREFIX}"/usr \
		$(use_enable gtk gnome)
}

src_compile() {
	# Avoid cargo_src_compile
	default
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

pkg_preinst() {
	use gtk && gnome2_gdk_pixbuf_savelist
}

pkg_postinst() {
	use gtk && gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	use gtk && gnome2_gdk_pixbuf_update
}
