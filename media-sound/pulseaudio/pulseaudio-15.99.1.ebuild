# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multilib-minimal

DESCRIPTION="A networked sound server with an advanced plugin system"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/PulseAudio/"
SRC_URI=""

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

LICENSE="metapackage"

SLOT="0"

IUSE="+alsa +alsa-plugin bluetooth +daemon +glib jack zeroconf"

# TODO: Get rid of the REQUIRED_USE by adapting the consumers to the splits with correct USE deps and dropping IUSE here
REQUIRED_USE="
	!daemon? (
		!alsa
		!alsa-plugin
		!bluetooth
		!jack
		!zeroconf
	)
"

RDEPEND="
	>=media-libs/libpulse-${PV}[glib?,${MULTILIB_USEDEP}]
	daemon? ( >=media-sound/pulseaudio-daemon-${PV}[alsa?,bluetooth?,jack?,zeroconf?] )
"
DEPEND="${RDEPEND}"
# TODO: Figure out alsa-plugin handling, where pulseaudio-daemon isn't a multilib-minimal package
PDEPEND="alsa? ( alsa-plugin? ( >=media-plugins/alsa-plugins-1.0.27-r1[pulseaudio,${MULTILIB_USEDEP}] ) )"
BDEPEND=""

S="${WORKDIR}"
