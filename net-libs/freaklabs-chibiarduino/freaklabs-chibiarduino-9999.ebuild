# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="freaklabs fork of the lightweight wireless sensor library for Arduino"
HOMEPAGE="https://freaklabs.org/chibiarduino/"
SRC_URI=""

inherit git-r3
EGIT_REPO_URI="https://github.com/freaklabs/chibiArduino.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="+promisc"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
PDEPEND="dev-embedded/arduino
		dev-embedded/freaklabs-boards"

src_prepare() {
	if use promisc; then
		sed -i 's#CHIBI_PROMISCUOUS 0#CHIBI_PROMISCUOUS 1#' chibiUsrCfg.h || die
	fi
	default
}

src_install() {
	insinto /usr/share/arduino/hardware/arduino/avr/libraries/chibi
	doins -r *
}

pkg_postinst() {
	ewarn "For this to work you need to install cross-avr/gcc[-ssp,-pie]"
	ewarn "Something like USE='-pie -ssp' crossdev -S -s4 avr"
}
