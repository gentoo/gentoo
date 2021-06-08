# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

MY_P=${PN}_${PV}

DESCRIPTION="A scalable icon theme called Faenza"
HOMEPAGE="https://tiheum.deviantart.com/art/Faenza-Icons-173323228"
# Use Ubuntu repo which has a proper faenza-icon-theme tarball
#SRC_URI="https://faenza-icon-theme.googlecode.com/files/${MY_P}.tar.gz"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="x11-themes/hicolor-icon-theme"

S="${WORKDIR}"/${PN}-${PV%.*}

src_prepare() {
	xdg_src_prepare
	local res x
	for x in Faenza Faenza-Dark; do
		for res in 22 24 32 48 64 96; do
			cp "${x}"/places/${res}/start-here-gentoo.png \
				"${x}"/places/${res}/start-here.png || die
		done
		cp "${x}"/places/scalable/start-here-gentoo.svg \
			"${x}"/places/scalable/start-here.svg || die
	done
}

src_install() {
	insinto /usr/share/icons
	doins -r Faenza{,-Ambiance,-Dark,-Darker,-Darkest,-Radiance}

	# TODO: Install to directories where the apps can find them
	# insinto ${somewhere}
	# doins -r emesene dockmanager rhythmbox
}
