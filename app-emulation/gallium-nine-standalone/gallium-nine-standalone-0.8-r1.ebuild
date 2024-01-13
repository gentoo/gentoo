# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson-multilib toolchain-funcs

MY_PN="wine-nine-standalone"
DESCRIPTION="A standalone version of the WINE parts of Gallium Nine"
HOMEPAGE="https://github.com/iXit/wine-nine-standalone"

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/iXit/${MY_PN}.git"
else
	SRC_URI="https://github.com/iXit/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="-* ~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

# We don't put Wine in RDEPEND because you can also use this with
# Steam's Proton.

RDEPEND="
	media-libs/mesa[d3d9,X(+),${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	virtual/wine[${MULTILIB_USEDEP}]
	>=dev-build/meson-0.50.1
"

PATCHES=(
	"${FILESDIR}"/0.8-cross-files.patch
	"${FILESDIR}"/0.3-nine-dll-path.patch
)

bits() {
	if [[ ${ABI} = amd64 ]]; then
		echo 64
	else
		echo 32
	fi
}

src_prepare() {
	default

	# Upstream includes a bootstrap.sh script with hardcoded CHOSTs to
	# create the Meson cross files. We improve on that here but also
	# inject CFLAGS and LDFLAGS, partly to simply respect these, and
	# partly to allow d3d9-nine.dll to be loaded from a location outside
	# WINEPREFIX. This avoids the need for the nine-install.sh script,
	# which doesn't play well with our multi-Wine environment.
	bootstrap_nine() {
		local file=tools/cross-wine$(bits)
		local g9dll=\"Z:${EPREFIX}/usr/$(get_libdir)/d3d9-nine.dll.so\"

		sed \
			-e "s!@PKG_CONFIG@!$(tc-getPKG_CONFIG)!" \
			-e "s!@CFLAGS@!$(_meson_env_array "${CFLAGS} '-DG9DLL=${g9dll}'")!" \
			-e "s!@LDFLAGS@!$(_meson_env_array "${LDFLAGS}")!" \
			-e "s!@PKG_CONFIG_LIBDIR@!${PKG_CONFIG_LIBDIR:-${ESYSROOT}/usr/$(get_libdir)/pkgconfig}!" \
			${file}.in > ${file} || die
	}

	multilib_foreach_abi bootstrap_nine
}

multilib_src_configure() {
	# We override bindir because otherwise the 32-bit exe is overwritten
	# by the 64-bit exe and we need both of them.
	local emesonargs=(
		--cross-file "${S}/tools/cross-wine$(bits)"
		--bindir "$(get_libdir)"
		-Ddistro-independent=false
		-Ddri2=false
	)
	meson_src_configure
}
