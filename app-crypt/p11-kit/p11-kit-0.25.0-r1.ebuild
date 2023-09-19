# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 meson-multilib

DESCRIPTION="Provides a standard configuration setup for installing PKCS#11"
HOMEPAGE="https://p11-glue.github.io/p11-glue/p11-kit.html"
SRC_URI="https://github.com/p11-glue/p11-kit/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+libffi gtk-doc nls systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-misc/ca-certificates
	>=dev-libs/libtasn1-3.4:=[${MULTILIB_USEDEP}]
	libffi? ( dev-libs/libffi:=[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-C_GetInterface.patch
)

multilib_src_configure() {
	# Disable unsafe tests, bug#502088
	export FAKED_MODE=1

	local emesonargs=(
		-Dbashcompdir="$(get_bashcompdir)"
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
