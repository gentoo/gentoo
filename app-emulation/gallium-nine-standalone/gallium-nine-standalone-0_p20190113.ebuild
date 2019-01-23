# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson multilib-minimal toolchain-funcs

DESCRIPTION="A standalone version of the WINE parts of Gallium Nine"
HOMEPAGE="https://github.com/dhewg/nine"

if [[ $PV = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dhewg/nine.git"
else
	COMMIT="e10dd1a770c91d5ff13343c9a0186665b7df6114"
	SRC_URI="https://github.com/dhewg/nine/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/nine-${COMMIT}"
	KEYWORDS="-* ~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

# We don't put Wine in RDEPEND because you can also use this with
# Steam's Proton.

RDEPEND="
	media-libs/mesa[d3d9,egl,${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	virtual/wine[${MULTILIB_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/flags.patch
	"${FILESDIR}"/nine-dll-path.patch
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
		local g9dll=Z:${EPREFIX//\//\\}\\usr\\$(get_libdir)\\d3d9-nine.dll.so

		# Yes, these ridiculous backslashes are needed!
		g9dll=\\\\\\\\\\\"${g9dll//\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\}\\\\\\\\\\\"

		sed \
			-e "s!@PKG_CONFIG@!$(tc-getPKG_CONFIG)!" \
			-e "s!@CFLAGS@!$(_meson_env_array "${CFLAGS} -DG9DLL=${g9dll}")!" \
			-e "s!@LDFLAGS@!$(_meson_env_array "${LDFLAGS}")!" \
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
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

pkg_postinst() {
	local bits=$(bits)

	einfo "Don't remove the Z: drive from your WINEPREFIX as this relies on it."
	einfo
	einfo "To set up the ${bits}-bit library, launch your preferred Wine as follows:"
	einfo "  wine${bits/32} ${EPREFIX}/usr/$(get_libdir)/ninewinecfg.exe.so"

	if use abi_x86_64 && use abi_x86_32; then
		einfo
		einfo "To set up the 32-bit library, launch your preferred Wine as follows:"
		einfo "  wine ${EPREFIX}/usr/$(ABI=x86 get_libdir)/ninewinecfg.exe.so"
	fi
}
