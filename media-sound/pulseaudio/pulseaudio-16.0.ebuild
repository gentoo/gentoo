# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multilib-minimal

DESCRIPTION="A networked sound server with an advanced plugin system"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/PulseAudio/"
SRC_URI=""

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

LICENSE="metapackage"

SLOT="0"

# NOTE: bluetooth, native-headset and ofono-headset are passed through to
# pulseaudio-daemon dependency to make sure users who have bluetooth enabled
# just for pulseaudio package will also get these enabled via metapackage.
IUSE="bluetooth +daemon +glib jack native-headset ofono-headset"

RDEPEND="
	>=media-libs/libpulse-${PV}[glib?,${MULTILIB_USEDEP}]
	daemon? ( >=media-sound/pulseaudio-daemon-${PV}[bluetooth?,glib?,jack?,native-headset?,ofono-headset?] )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"
