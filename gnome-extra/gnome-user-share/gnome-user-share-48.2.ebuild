# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_OPTIONAL=1
LLVM_COMPAT=( {17..21} )
RUST_MIN_VER="1.80.0"
CRATES="
	aho-corasick@1.1.3
	autocfg@1.3.0
	bindgen@0.69.4
	bitflags@2.6.0
	block@0.1.6
	cc@1.0.97
	cexpr@0.6.0
	cfg-expr@0.17.0
	cfg-if@1.0.0
	clang-sys@1.8.1
	dunce@1.0.4
	either@1.13.0
	equivalent@1.0.1
	errno@0.3.9
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.31
	futures-macro@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	gettext-rs@0.7.0
	gettext-sys@0.21.3
	gio-sys@0.20.4
	gio@0.20.4
	glib-macros@0.20.4
	glib-sys@0.20.4
	glib@0.20.4
	glob@0.3.1
	gobject-sys@0.20.4
	hashbrown@0.14.5
	heck@0.5.0
	home@0.5.9
	indexmap@2.2.6
	itertools@0.12.1
	lazy_static@1.4.0
	lazycell@1.3.0
	libc@0.2.154
	libloading@0.8.4
	linux-raw-sys@0.4.14
	locale_config@0.3.0
	log@0.4.21
	malloc_buf@0.0.6
	memchr@2.7.4
	minimal-lexical@0.2.1
	nom@7.1.3
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	once_cell@1.19.0
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	pkg-config@0.3.30
	prettyplease@0.2.20
	proc-macro-crate@3.1.0
	proc-macro2@1.0.88
	quote@1.0.36
	reference-counted-singleton@0.1.4
	regex-automata@0.4.6
	regex-syntax@0.8.3
	regex@1.10.4
	rustc-hash@1.1.0
	rustix@0.38.34
	same-file@1.0.6
	selinux-sys@0.6.9
	selinux@0.4.4
	serde@1.0.202
	serde_derive@1.0.202
	serde_spanned@0.6.6
	shlex@1.3.0
	slab@0.4.9
	smallvec@1.13.2
	syn@2.0.79
	system-deps@7.0.3
	target-lexicon@0.12.16
	temp-dir@0.1.13
	thiserror-impl@1.0.60
	thiserror@1.0.60
	toml@0.8.13
	toml_datetime@0.6.6
	toml_edit@0.21.1
	toml_edit@0.22.13
	unicode-ident@1.0.12
	version-compare@0.2.0
	walkdir@2.5.0
	which@4.4.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
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
"

inherit cargo gnome.org gnome2-utils llvm-r2 meson systemd xdg

DESCRIPTION="Personal file sharing for the GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-user-share"
SRC_URI+="
	${SRC_URI}
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-2"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="selinux"
REQUIRED_USE="
	selinux? ( ${LLVM_REQUIRED_USE} )
"

RDEPEND="
	>=dev-libs/glib-2.74.0:2
	>=www-apache/mod_dnssd-0.6
	>=www-servers/apache-2.4[apache2_modules_dav,apache2_modules_dav_fs,apache2_modules_authn_file,apache2_modules_auth_digest,apache2_modules_authz_groupfile]
	selinux? (
		>=sys-libs/libselinux-2.8
		$(llvm_gen_dep '
			llvm-core/clang:${LLVM_SLOT}=
		')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# Upstream forces to use prefork because of Fedora defaults, but
	# that is problematic for us (bug #551012)
	# https://bugzilla.gnome.org/show_bug.cgi?id=750525#c2
	"${FILESDIR}"/${PN}-3.18.1-no-prefork.patch
)

src_configure() {
	local emesonargs=(
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		-Dhttpd=apache2
		-Dmodules_path=/usr/$(get_libdir)/apache2/modules/
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
