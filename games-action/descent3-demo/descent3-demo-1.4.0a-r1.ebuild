# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker xdg

DESCRIPTION="Indoor/outdoor 3D combat with evil robotic mining spacecraft"
HOMEPAGE="http://www.lokigames.com/products/descent3/"
SRC_URI="mirror://lokigames/loki_demos/${PN}.run"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa pulseaudio"
REQUIRED_USE="?? ( alsa pulseaudio )"
RESTRICT="bindist mirror strip"

DEPEND="games-util/loki_patch"
RDEPEND="sys-libs/glibc
	>=virtual/opengl-7.0-r1[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
	alsa? ( media-libs/alsa-oss[abi_x86_32(-)] )
	pulseaudio? ( media-sound/pulseaudio[abi_x86_32(-)] )"

dir="/opt/${PN}"
QA_PREBUILT="${dir:1}/descent3_demo.x86
	${dir:1}/netgames/*.d3m"

S="${WORKDIR}"

src_install() {
	local \
		snd= \
		demo="data/demos/descent3_demo" \
		exe="descent3_demo.x86"

	loki_patch patch.dat data/ || die

	insinto "${dir}"
	exeinto "${dir}"
	doins -r "${demo}"/*
	doexe "${demo}/${exe}"

	# Required directory
	keepdir "${dir}"/missions

	# Fix for 2.6 kernel crash, bug #151148
	dosym ppics.hog "${dir}"/PPics.Hog

	if use alsa; then
		snd="aoss "
	elif use pulseaudio; then
		snd="env LD_PRELOAD=\"${EPREFIX}/usr/$(ABI=x86 get_libdir)/pulseaudio/libpulsedsp.so\" "
	fi

	make_wrapper ${PN} "${snd}./${exe} -G -o" "${dir}"
	newicon "${demo}"/launch/box.png ${PN}.png
	make_desktop_entry ${PN} "Descent 3 (Demo)"
}

pkg_postinst() {
	xdg_pkg_postinst

	echo
	elog "To play the game run:"
	elog " descent3-demo"
	elog
	elog "If the game appears blank, then run it windowed with:"
	elog " descent3-demo -w"
	echo
}
