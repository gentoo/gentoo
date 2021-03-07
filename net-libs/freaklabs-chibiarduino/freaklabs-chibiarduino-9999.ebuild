# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="freaklabs fork of the lightweight wireless sensor library for Arduino"
HOMEPAGE="https://freaklabs.org/chibiarduino/"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/freaklabs/chibiArduino.git"
else
	GIT_COMMIT="547ec8155c48b7eaa9aa8f1bd88a55c7ffd55868"
	SRC_URI="https://github.com/freaklabs/chibiArduino/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/chibiArduino-${GIT_COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
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
	insinto /usr/share/arduino/hardware/arduino/avr/libraries/chibiarduino
	doins -r *
}

pkg_postinst() {
	ewarn "For this to work you need to install cross-avr/gcc[-ssp,-pie]"
	ewarn "Something like USE='-pie -ssp' crossdev -S -s4 avr"
}
