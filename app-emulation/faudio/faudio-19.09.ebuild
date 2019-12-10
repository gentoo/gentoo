# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# shellcheck disable=SC2034
EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake-multilib virtualx

FAUDIO_PN="FAudio"
FAUDIO_PV="${PV}"
FAUDIO_P="${FAUDIO_PN}-${FAUDIO_PV}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FNA-XNA/${FAUDIO_PN}.git"
else
	SRC_URI="https://github.com/FNA-XNA/${FAUDIO_PN}/archive/${FAUDIO_PV}.tar.gz -> ${FAUDIO_P}.tar.gz"
	KEYWORDS="-* ~amd64 ~x86"
	S="${WORKDIR}/${FAUDIO_P}"
fi

DESCRIPTION="FAudio - Accuracy-focused XAudio reimplementation for open platforms"
HOMEPAGE="https://fna-xna.github.io/"
LICENSE="ZLIB"
SLOT="0"

IUSE="+abi_x86_32 +abi_x86_64 debug ffmpeg xnasong test utils"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )"

COMMON_DEPEND="
	>=media-libs/libsdl2-2.0.9[sound,${MULTILIB_USEDEP}]
	ffmpeg? ( media-video/ffmpeg:=[${MULTILIB_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
"
DEPEND="${COMMON_DEPEND}
"

multilib_src_configure() {
	local mycmakeargs=(
		"-DCMAKE_INSTALL_BINDIR=bin"
		"-DCMAKE_INSTALL_INCLUDEDIR=include/${FAUDIO_PN}"
		"-DCMAKE_INSTALL_LIBDIR=$(get_libdir)"
		"-DCMAKE_INSTALL_PREFIX=${EPREFIX%/}/usr"
		"-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)"
		"-DFORCE_ENABLE_DEBUGCONFIGURATION=$(usex debug ON OFF)"
		"-DBUILD_TESTS=$(usex test ON OFF)"
		"-DBUILD_UTILS=$(usex utils ON OFF)"
		"-DFFMPEG=$(usex ffmpeg ON OFF)"
		"-DXNASONG=$(usex xnasong ON OFF)"
	)
	if use ffmpeg; then
		mycmakeargs+=( "-DFFmpeg_LIBRARY_DIRS=${EPREFIX%/}/usr/$(get_libdir)"  )
	fi
	cmake-utils_src_configure
}

src_configure() {
	cmake-multilib_src_configure
}

multilib_src_compile() {
	cmake-utils_src_make
	emake -C "${BUILD_DIR}" all
}

multilib_src_install() {
	# FIXME: do we want to install the FAudio tools?
	cmake-utils_src_install

	sed -e "s@%LIB%@$(get_libdir)@g" -e "s@%PREFIX%@${EPREFIX}/usr@g" \
		"${FILESDIR}/faudio.pc" > "${T}/faudio.pc" \
		|| die "sed failed"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${T}/faudio.pc"

	if use test; then
		mkdir -p "${T}/$(get_libdir)"
		cp "${BUILD_DIR}/faudio_tests" "${T}/$(get_libdir)/" || die "cp failed"
	fi
}

faudio_test() {
	XDG_RUNTIME_DIR="/run/user/0" virtx "${T}/$(get_libdir)/faudio_tests"
}

pkg_postinst() {
	use test || return

	# FIXME: FAudio tests are broken and also don't appear to work
	# in the Portage sandbox.
	multilib_foreach_abi faudio_test
}
