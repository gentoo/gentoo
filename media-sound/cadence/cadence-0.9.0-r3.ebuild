# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit python-single-r1 xdg desktop

DESCRIPTION="Collection of tools useful for audio production"
HOMEPAGE="http://kxstudio.linuxaudio.org/Applications:Cadence"
SRC_URI="https://github.com/falkTX/Cadence/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64"
LICENSE="GPL-2"
SLOT="0"

IUSE="a2jmidid -pulseaudio opengl"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# for jack project rendering also needs media-sound/jack_capture which is not in the tree yet
CDEPEND="
	${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/PyQt5[dbus,gui,opengl?,svg,widgets,${PYTHON_USEDEP}]
	media-sound/jack2[dbus]
	media-sound/jack_capture
	a2jmidid? ( media-sound/a2jmidid[dbus] )
	pulseaudio? ( media-sound/pulseaudio[jack] )
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

S="${WORKDIR}/Cadence-${PV}"

PATCHES=( "${FILESDIR}"/${PN}-add-skip-stripping.patch )

src_prepare() {
	sed -i -e "s/python3/${EPYTHON}/" \
		data/cadence \
		data/cadence-aloop-daemon \
		data/cadence-jacksettings \
		data/cadence-logs \
		data/cadence-render \
		data/cadence-session-start \
		data/catarina \
		data/catia \
		data/claudia \
		data/claudia-launcher || die "sed failed"

	default
}

src_compile() {
	myemakeargs=(PREFIX="/usr"
		SKIP_STRIPPING=true
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install

	# Clean up stuff that shouldn't be installed
	rm -rf "${D}"/etc/X11/xinit/xinitrc.d/61cadence-session-inject
	rm -rf "${D}"/etc/xdg/autostart/cadence-session-start.desktop
	rm -rf "${D}"/usr/share/applications/*.desktop

	if use !pulseaudio; then
		rm -rf "${D}"/usr/bin/cadence-pulse2{jack,loopback}
		rm -rf "${D}"/usr/share/cadence/pulse2{jack,loopback}
	fi

	# Replace desktop entries with QA issues with these
	make_desktop_entry cadence Cadence cadence "AudioVideo;AudioVideoEditing;Qt"
	make_desktop_entry catia Catia catia "AudioVideo;AudioVideoEditing;Qt"
	make_desktop_entry catarina Catarina catarina "AudioVideo;AudioVideoEditing;Qt"
}
