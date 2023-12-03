# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Digital audio workstation"
HOMEPAGE="https://www.reaper.fm"

SRC_URI="
	amd64? ( https://www.reaper.fm/files/$(ver_cut 1).x/reaper$(ver_cut 1)$(printf %02d $(ver_cut 2))_linux_x86_64.tar.xz )
	x86? ( https://www.reaper.fm/files/$(ver_cut 1).x/reaper$(ver_cut 1)$(printf %02d $(ver_cut 2))_linux_i686.tar.xz )
	arm64? ( https://www.reaper.fm/files/$(ver_cut 1).x/reaper$(ver_cut 1)$(printf %02d $(ver_cut 2))_linux_aarch64.tar.xz )
	arm? ( https://www.reaper.fm/files/$(ver_cut 1).x/reaper$(ver_cut 1)$(printf %02d $(ver_cut 2))_linux_armv7l.tar.xz )
"

LICENSE="Cockos"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

IUSE="+jack pulseaudio mp3 ffmpeg"

RDEPEND="
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/libglvnd
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXi
	jack? ( virtual/jack )
	pulseaudio? ( media-libs/libpulse )
	mp3? ( media-sound/lame )
	ffmpeg? ( media-video/ffmpeg )
"

S="${WORKDIR}"

QA_PREBUILT="*/*.so */reaper */reaper_host_*"

src_install() {
	local -A ARCH_MAP=(
		[amd64]=x86_64
		[x86]=i686
		[arm64]=aarch64
		[arm]=armv7l
	)
	cd "reaper_linux_${ARCH_MAP[$ARCH]}" || die
	./install-reaper.sh --install "${D}"/opt || die
	rm -f "${D}"/opt/REAPER/uninstall-reaper.sh

	dosym ../../opt/REAPER/reaper /usr/bin/reaper

	# The following is pulled out of install-reaper.sh to match desktop.eclass.
	cd REAPER || die

	newicon -s 256 Resources/main.png cockos-reaper.png
	doicon -s 256 Resources/cockos-reaper-backup.png
	doicon -s 256 Resources/cockos-reaper-document.png
	doicon -s 256 Resources/cockos-reaper-theme.png
	doicon -s 256 Resources/cockos-reaper-peak.png
	doicon -s 256 Resources/cockos-reaper-template.png
	doicon -s 256 Resources/cockos-reaper-template2.png

	cat > cockos-reaper.desktop <<-EOF
	[Desktop Entry]
	Encoding=UTF-8
	Type=Application
	Name=REAPER
	Comment=REAPER
	Categories=Audio;Video;AudioVideo;AudioVideoEditing;Recorder;
	Exec="/usr/bin/reaper" %F
	Icon=cockos-reaper
	MimeType=application/x-reaper-project;application/x-reaper-project-backup;application/x-reaper-theme
	StartupWMClass=REAPER
	EOF
	domenu cockos-reaper.desktop

	cat > application-x-reaper.xml <<-EOF
	<?xml version="1.0" encoding="UTF-8"?>
	<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
	  <mime-type type="application/x-reaper-project">
		<sub-class-of type="text/plain"/>
		<comment xml:lang="en">REAPER project</comment>
		<icon name="cockos-reaper-document"/>
		<glob pattern="*.rpp"/>
	  </mime-type>
	  <mime-type type="application/x-reaper-project-backup">
		<sub-class-of type="text/plain"/>
		<comment xml:lang="en">REAPER project backup</comment>
		<icon name="cockos-reaper-backup"/>
		<glob pattern="*.rpp-bak"/>
	  </mime-type>
	  <mime-type type="application/x-reaper-config">
		<sub-class-of type="text/plain"/>
		<icon name="cockos-reaper"/>
		<comment xml:lang="en">REAPER configuration</comment>
		<glob pattern="reaper*.ini"/>
	  </mime-type>
	  <mime-type type="application/x-reaper-fxchain">
		<sub-class-of type="text/plain"/>
		<comment xml:lang="en">REAPER fx chain</comment>
		<icon name="cockos-reaper-template"/>
		<glob pattern="*.rfxchain"/>
	  </mime-type>
	  <mime-type type="application/x-reaper-tracktemplate">
		<sub-class-of type="text/plain"/>
		<comment xml:lang="en">REAPER track template</comment>
		<icon name="cockos-reaper-template2"/>
		<glob pattern="*.RTrackTemplate"/>
	  </mime-type>
	  <mime-type type="application/x-reaper-theme">
		<comment xml:lang="en">REAPER theme</comment>
		<icon name="cockos-reaper-theme"/>
		<glob pattern="*.ReaperTheme"/>
		<glob pattern="*.ReaperThemeZip"/>
	  </mime-type>
	  <mime-type type="application/x-reaper-undo">
		<icon name="cockos-reaper-backup"/>
		<comment xml:lang="en">REAPER undo</comment>
		<glob pattern="*.rpp-undo"/>
	  </mime-type>
	  <mime-type type="application/x-reaper-bak-undo">
		<icon name="cockos-reaper-backup"/>
		<comment xml:lang="en">REAPER undo backup</comment>
		<glob pattern="*.rpp-bak-undo"/>
	  </mime-type>
	  <mime-type type="application/x-reaper-peak">
		<comment xml:lang="en">REAPER peak file</comment>
		<icon name="cockos-reaper-peak"/>
		<glob pattern="*.reapeaks"/>
	  </mime-type>
	  <mime-type type="application/x-reaper-proxy">
		<icon name="cockos-reaper-peak"/>
		<comment xml:lang="en">REAPER proxy</comment>
		<glob pattern="*.rpp-prox"/>
	  </mime-type>
	</mime-info>
	EOF
	insopts -m 0644
	insinto /usr/share/mime
	doins application-x-reaper.xml
}
