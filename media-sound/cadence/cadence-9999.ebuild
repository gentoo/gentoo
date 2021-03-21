# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit python-single-r1 xdg desktop

DESCRIPTION="Collection of tools useful for audio production"
HOMEPAGE="https://kxstudio.linuxaudio.org/Applications:Cadence"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/falkTX/Cadence.git"
else
	SRC_URI="https://github.com/falkTX/Cadence/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/Cadence-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="a2jmidid -pulseaudio opengl"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		dev-python/PyQt5[dbus,gui,opengl?,svg,widgets,${PYTHON_MULTI_USEDEP}]
	')
	media-sound/jack_capture
	virtual/jack
	a2jmidid? ( media-sound/a2jmidid[dbus] )
	pulseaudio? ( media-sound/pulseaudio[jack] )
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.1-fix-clang.patch
)

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
	myemakeargs=(PREFIX="${EPREFIX}/usr"
		SKIP_STRIPPING=true
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${ED}" install

	python_fix_shebang "${ED}"

	# Clean up stuff that shouldn't be installed
	rm -rf "${ED}"/etc/X11/xinit/xinitrc.d/61cadence-session-inject
	rm -rf "${ED}"/etc/xdg/autostart/cadence-session-start.desktop
	rm -rf "${ED}"/usr/share/applications/*.desktop

	if use !pulseaudio; then
		rm -rf "${ED}"/usr/bin/cadence-pulse2{jack,loopback}
		rm -rf "${ED}"/usr/share/cadence/pulse2{jack, loopback}
	fi
	# Depend on ladish which is not in the tree
	rm -rf "${ED}"/usr/bin/claudia{,-launcher}
	rm -rf "${ED}"/usr/share/cadence/icons/claudia-hicolor/

	# Replace desktop entries with QA issues with these
	make_desktop_entry cadence Cadence cadence "AudioVideo;AudioVideoEditing;Qt"
	make_desktop_entry catia Catia catia "AudioVideo;AudioVideoEditing;Qt"
	make_desktop_entry catarina Catarina catarina "AudioVideo;AudioVideoEditing;Qt"
}
