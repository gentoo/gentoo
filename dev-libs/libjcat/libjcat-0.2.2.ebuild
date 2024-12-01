# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"

inherit meson python-any-r1 vala xdg-utils

DESCRIPTION="Library and tool for reading and writing Jcat files"
HOMEPAGE="https://github.com/hughsie/libjcat"
SRC_URI="https://github.com/hughsie/libjcat/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ppc64 ~riscv x86"
IUSE="+ed25519 +gpg gtk-doc +introspection +man +pkcs7 test vala"

RDEPEND="
	dev-libs/glib:2
	dev-libs/json-glib:=
	ed25519? (
		net-libs/gnutls:=
	)
	gpg? (
		app-crypt/gpgme:=
		dev-libs/libgpg-error
	)
	introspection? ( dev-libs/gobject-introspection:= )
	pkcs7? ( net-libs/gnutls:= )
	vala? ( dev-lang/vala:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	gtk-doc? ( dev-util/gtk-doc )
	man? ( sys-apps/help2man )
	test? ( net-libs/gnutls[tools] )
"

RESTRICT="!test? ( test )"

python_check_deps() {
	python_has_version -b "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use vala && vala_setup
}

src_prepare() {
	xdg_environment_reset
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use ed25519)
		$(meson_use gtk-doc gtkdoc)
		$(meson_use gpg)
		$(meson_use introspection)
		$(meson_use man)
		$(meson_use pkcs7)
		$(meson_use test tests)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use test; then
		# Preventing tests from being installed in the first place is a moving target,
		# just axe them all afterwards.
		rm -rf \
			"${ED}"/usr/libexec/installed-tests \
			"${ED}"/usr/share/installed-tests \
			|| die
	fi
}
