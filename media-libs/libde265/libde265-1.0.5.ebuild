# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

PATCHES=( "${FILESDIR}/${PN}-1.0.2-qtbindir.patch" )

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/strukturag/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/strukturag/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
fi

DESCRIPTION="Open h.265 video codec implementation"
HOMEPAGE="https://github.com/strukturag/libde265"

LICENSE="GPL-3"
SLOT="0"
IUSE="enc265 dec265 sdl tools debug static-libs cpu_flags_x86_sse4_1 cpu_flags_arm_neon cpu_flags_arm_thumb"
# IUSE+=" sherlock265" # Require libvideogfx or libswscale

RDEPEND="
	dec265? (
		sdl? ( media-libs/libsdl )
	)
"
# Sherlock265 require libvideogfx or libswscale
#RDEPEND+="
#	sherlock265? (
#		media-libs/libsdl
#		dev-qt/qtcore:5
#		dev-qt/qtgui:5
#		dev-qt/qtwidgets:5
#		media-libs/libswscale
#	)
#"

DEPEND="${RDEPEND}"

BDEPEND="dec265? ( virtual/pkgconfig )"

# Sherlock265 require libvideogfx or libswscale
#BDEPEND+=" sherlock265? ( virtual/pkgconfig )"

src_prepare() {
	default

	eautoreconf

	# without this, headers would be missing and make would fail
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		ax_cv_check_cflags___msse4_1=$(usex cpu_flags_x86_sse4_1)
		ax_cv_check_cflags___mfpu_neon=$(usex cpu_flags_arm_neon)
		$(use_enable cpu_flags_arm_thumb thumb)
		$(use_enable static-libs static)
		$(use_enable debug log-info)
		$(use_enable debug log-debug)
		$(use_enable debug log-trace)
		$(multilib_native_use_enable enc265 encoder)
		$(multilib_native_use_enable dec265)
		--enable-log-error
	)

	# myeconfargs+=( $(multilib_native_use_enable sherlock265) ) # Require libvideogfx or libswscale
	myeconfargs+=( --disable-sherlock265 )

	econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		# Remove useless, unready and test tools (Why package ever tried to install them??)
		rm -f "${ED}/usr/bin/"{tests,gen-enc-table,yuv-distortion} || die
		if ! use tools; then
			rm -f "${ED}/usr/bin/"{bjoentegaard,block-rate-estim,rd-curves} || die
			rm -f "${ED}/usr/bin/acceleration_speed" || die
		fi
	else
		# Remove all non-native binary tools
		rm -f "${ED}/usr/bin/"* || die
	fi
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
