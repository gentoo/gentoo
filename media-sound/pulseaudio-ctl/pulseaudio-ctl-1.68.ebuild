# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="CLI utility to control PulseAudio volume"
HOMEPAGE="https://github.com/graysky2/pulseaudio-ctl"
SRC_URI="https://github.com/graysky2/pulseaudio-ctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Optional runtime deps: dbus-send for KDE OSD, notify-send for libnotify
# in both cases they should be already present if DE supports them
RDEPEND="media-sound/pulseaudio"

src_install() {
	emake install PREFIX="${EPREFIX}/usr" DESTDIR="${D}"
}
