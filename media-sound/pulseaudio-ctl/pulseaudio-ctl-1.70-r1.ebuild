# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CLI utility to control PulseAudio volume"
HOMEPAGE="https://github.com/graysky2/pulseaudio-ctl"
SRC_URI="
	https://github.com/graysky2/pulseaudio-ctl/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

# Optional runtime deps: dbus-send for KDE OSD, notify-send for libnotify
# in both cases they should be already present if DE supports them
RDEPEND="
	|| (
		(
			media-libs/libpulse
			media-sound/pulseaudio-daemon
		)
		media-sound/pulseaudio[daemon(+)]
	)
"

src_install() {
	emake install PREFIX="${EPREFIX}/usr" DESTDIR="${D}"
}
