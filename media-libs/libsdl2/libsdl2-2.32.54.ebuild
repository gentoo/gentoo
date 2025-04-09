# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

# TODO: switch to new description when non-compat is gone, this is so it is
# not displayed on packages.gentoo.org which may be confusing for users
DESCRIPTION="Simple Direct Media Layer"
#DESCRIPTION="Simple Direct Media Layer 2 compatibility wrapper around SDL3"
HOMEPAGE="https://www.libsdl.org/"
SRC_URI="https://www.libsdl.org/release/sdl2-compat-${PV}.tar.gz"
S=${WORKDIR}/sdl2-compat-${PV}

LICENSE="ZLIB"
SLOT="0"
# unkeyworded for testing
#KEYWORDS="~amd64"
# this skips most non-compat libsdl2 former IUSE that are not used by revdeps,
# albeit it is questionable that some depend on audio alsa/pipewire (note that
# static-libs is left out because it is useless for static-only builds given
# it will dlopen the shared libsdl3 anyway)
#
# TODO: either update revdeps to have (+) on no-op IUSE (haptic, joystick,
# sound, and video) then cleanup, or don't for less overlay issues and instead
# force in profiles to avoid unnecessary rebuilds -- not forced right now given
# >=2.32.50 would force for a potential future non-compat 2.34.0 fwiw
IUSE="
	X alsa gles2 +haptic +joystick kms opengl pipewire pulseaudio
	+sound test +video vulkan wayland
"
REQUIRED_USE="gles2? ( opengl )"
RESTRICT="!test? ( test )"

# libsdl3 is dlopen'ed and USE at build time should not matter, it enables
# everything but will not work without libsdl3 support at runtime
RDEPEND="
	media-libs/libsdl3[X?,alsa?,opengl?,pipewire?,pulseaudio?,vulkan?,wayland?,${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DSDL2COMPAT_TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install

	rm -r -- "${ED}"/usr/share/licenses || die
}
