# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Arduino hardware definitions for freaklabs boards"
HOMEPAGE="https://freaklabs.org/chibiarduino/"

#this is for 1.0.3 from git but it doesn't seem to work
#GIT_COMMIT="ff3ebd11934c123091d485e6dc2845d78bda4255"
#SRC_URI="https://github.com/freaklabs/freaklabs-boards/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
#S="${WORKDIR}/${PN}-${GIT_COMMIT}"
S="${WORKDIR}/freaklabs-v1.0.0"

SRC_URI="https://freaklabs.org/pub/chibiArduino/boards/freaklabs-v${PV}-manual%20install.zip -> freaklabs-v${PV}-manual-install.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
PDEPEND="dev-embedded/arduino"

src_install() {
	insinto /usr/share/arduino/hardware/freaklabs/avr
	doins -r avr/*
	#non working 1.0.3
	#doins -r boards/1.0.3/{boards.txt,platform.local.txt,variants,bootloaders}
}

pkg_postinst() {
	ewarn "For this to work you need to install cross-avr/gcc[-ssp,-pie]"
	ewarn "Something like USE='-pie -ssp' crossdev -S -s4 avr"
}
