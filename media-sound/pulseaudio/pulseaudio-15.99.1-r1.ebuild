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

IUSE="+daemon +glib"

RDEPEND="
	>=media-libs/libpulse-${PV}[glib?,${MULTILIB_USEDEP}]
	daemon? ( >=media-sound/pulseaudio-daemon-${PV} )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"
