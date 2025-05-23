# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit savedconfig toolchain-funcs python-any-r1 scons-utils

DESCRIPTION="Not (so) simple terminal emulator for X"
HOMEPAGE="https://www.github.com/gerstner-hub/nst"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://www.github.com/gerstner-hub/${PN}.git"
else
	SRC_URI="https://github.com/gerstner-hub/nst/releases/download/v${PV}/nst-v${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

S="${WORKDIR}/nst-v${PV}"
LICENSE="MIT"
SLOT="0"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-build/scons
	virtual/pkgconfig
"

src_prepare() {
	default
	restore_config src/nst_config.hxx
}

src_compile() {
	# run Scons but also make sure CC, CFLAGS etc. are honored
	local sconsargs=(
		AR="$(tc-getAR)" CC="$(tc-getCC)" CXX="$(tc-getCXX)"
		RANLIB="$(tc-getRANLIB)" CPPFLAGS="${CPPFLAGS}"
		CFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}"
		progress=no verbose=yes
	)

	escons "${sconsargs[@]}"
}

src_install() {
	# install into local EPREFIX/usr via scons
	INSTROOT="${D}/${EPREFIX}"
	escons install instroot="${INSTROOT}/usr"
	mkdir "${INSTROOT}/etc"
	mv "${INSTROOT}/usr/etc/nst.conf" "${INSTROOT}/etc/nst.conf"
	rmdir "${INSTROOT}/usr/etc"

	save_config src/nst_config.hxx
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Please ensure a usable font is installed, like"
		elog "    media-fonts/corefonts"
		elog "    media-fonts/dejavu"
		elog "    media-fonts/urw-fonts"
	fi
}
