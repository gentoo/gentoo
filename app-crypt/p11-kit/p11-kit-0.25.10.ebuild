# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/p11-kit.asc
inherit shell-completion meson-multilib python-any-r1 verify-sig

DESCRIPTION="Provides a standard configuration setup for installing PKCS#11"
HOMEPAGE="https://p11-glue.github.io/p11-glue/p11-kit.html"
SRC_URI="
	https://github.com/p11-glue/p11-kit/releases/download/${PV}/${P}.tar.xz
	verify-sig? ( https://github.com/p11-glue/p11-kit/releases/download/${PV}/${P}.tar.xz.sig )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="+libffi gtk-doc nls systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-misc/ca-certificates
	>=dev-libs/libtasn1-3.4:=[${MULTILIB_USEDEP}]
	libffi? ( dev-libs/libffi:=[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-p11-kit )
"

src_prepare() {
	default

	# Relies on dlopen which won't work for multilib tests (bug #913971)
	cat <<-EOF > "${S}"/p11-kit/test-server.sh || die
	#!/bin/sh
	exit 77
	EOF
}

multilib_src_configure() {
	# Disable unsafe tests, bug#502088
	export FAKED_MODE=1

	local native_file="${T}"/meson.${CHOST}.${ABI}.ini.local

	# p11-kit doesn't need this to build and castxml needs Clang. To get
	# a deterministic non-automagic build, always disable the search for
	# castxml.
	cat >> ${native_file} <<-EOF || die
	[binaries]
	castxml='castxml-falseified'
	EOF

	local emesonargs=(
		--native-file "${native_file}"
		-Dbash_completion=enabled
		-Dzsh_completion=enabled
		-Dbashcompdir="$(get_bashcompdir)"
		-Dzshcompdir="$(get_zshcompdir)"
		-Dtrust_module=enabled
		-Dtrust_paths="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
		$(meson_feature libffi)
		$(meson_use nls)
		$(meson_use test)
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_true man)
		$(meson_native_use_feature systemd)
	)

	meson_src_configure
}
