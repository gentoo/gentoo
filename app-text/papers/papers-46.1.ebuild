# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.18
	autocfg@1.3.0
	bitflags@2.5.0
	block@0.1.6
	cc@1.0.97
	cfg-expr@0.15.8
	cfg-if@1.0.0
	env_logger@0.10.2
	equivalent@1.0.1
	errno@0.3.9
	fastrand@2.1.0
	field-offset@0.3.6
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	gettext-rs@0.7.0
	gettext-sys@0.21.3
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.9
	humantime@2.1.0
	indexmap@2.2.6
	is-terminal@0.4.12
	lazy_static@1.4.0
	libc@0.2.154
	linux-raw-sys@0.4.13
	locale_config@0.3.0
	log@0.4.21
	lru@0.12.3
	malloc_buf@0.0.6
	memchr@2.7.2
	memoffset@0.9.1
	objc@0.2.7
	objc-foundation@0.1.1
	objc_id@0.1.1
	once_cell@1.19.0
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	pkg-config@0.3.30
	proc-macro-crate@3.1.0
	proc-macro2@1.0.82
	quote@1.0.36
	regex@1.10.4
	regex-automata@0.4.6
	regex-syntax@0.8.3
	rustc_version@0.4.0
	rustix@0.38.34
	semver@1.0.23
	serde@1.0.201
	serde_derive@1.0.201
	serde_spanned@0.6.5
	shell-words@1.1.0
	slab@0.4.9
	smallvec@1.13.2
	syn@2.0.62
	system-deps@6.2.2
	target-lexicon@0.12.14
	temp-dir@0.1.13
	tempfile@3.10.1
	termcolor@1.4.1
	thiserror@1.0.60
	thiserror-impl@1.0.60
	toml@0.8.12
	toml_datetime@0.6.5
	toml_edit@0.21.1
	toml_edit@0.22.12
	unicode-ident@1.0.12
	version-compare@0.2.0
	version_check@0.9.4
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.52.0
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.52.5
	winnow@0.5.40
	winnow@0.6.8
	zerocopy@0.7.34
	zerocopy-derive@0.7.34
"

inherit cargo gnome.org gnome2-utils meson xdg

DESCRIPTION="A document viewer for the GNOME desktop"
HOMEPAGE="https://apps.gnome.org/Papers"

SRC_URI+=" ${CARGO_CRATE_URIS}"
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions CC-BY-SA-3.0 BSD-2 GPL-2+ MIT Unicode-DFS-2016 Unlicense"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="cups djvu gstreamer gnome keyring gtk-doc +introspection nautilus postscript spell tiff xps"
REQUIRED_USE="gtk-doc? ( introspection )"

# atk used in libview
# bundles unarr
DEPEND="
	>=x11-libs/gdk-pixbuf-2.40:2
	>=dev-libs/glib-2.75.0:2
	>=gui-libs/gtk-4.13.8[cups?,introspection?]
	>=gui-libs/libadwaita-1.5.0
	>=media-libs/exempi-2.0
	>=x11-libs/cairo-1.14
	nautilus? ( gnome-base/nautilus )
	sys-libs/zlib:=
	gnome-base/gsettings-desktop-schemas
	>=app-text/poppler-22.05.0:=[cairo]
	>=app-arch/libarchive-3.6.0:=
	djvu? ( >=app-text/djvu-3.5.22:= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0 )
	gnome? ( gnome-base/gnome-desktop:3= )
	keyring? ( >=app-crypt/libsecret-0.5 )
	introspection? ( >=dev-libs/gobject-introspection-1:= )
	postscript? ( >=app-text/libspectre-0.2:= )
	spell? ( >=app-text/gspell-1.6.0:= )
	tiff? ( >=media-libs/tiff-4.0:= )
	xps? ( >=app-text/libgxps-0.2.1:= )
"
RDEPEND="${DEPEND}
	gnome-base/gvfs
	gnome-base/librsvg
"
BDEPEND="
	gtk-doc? (
		>=dev-util/gi-docgen-2021.1
		app-text/docbook-xml-dtd:4.3
	)
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	>=virtual/rust-1.53
"

QA_FLAGS_IGNORED="usr/bin/${PN} usr/bin/${PN}-monitor"

PATCHES=(
	# "${FILESDIR}/meson-fixes.patch"
)

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Dprofile=default
		-Dplatform=gnome

		-Dviewer=true
		-Dpreviewer=true
		-Dthumbnailer=true
		$(meson_use nautilus)

		-Dcomics=enabled
		$(meson_feature djvu)
		-Dpdf=enabled
		$(meson_feature postscript ps)
		$(meson_feature tiff)
		$(meson_feature xps)

		$(meson_use gtk-doc gtk_doc)
		-Duser_doc=true
		$(meson_use introspection)
		-Ddbus=true
		$(meson_feature keyring)
		$(meson_feature cups gtk_unix_print)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install

	if use gtk-doc; then
	   mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
	   mv "${ED}"/usr/share/doc/{libevdocument,libevview} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
