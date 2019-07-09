# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

SDCC_DEPEND=">=dev-embedded/sdcc-2.9.0[device-lib(+),mcs51(+),sdcpp(+)]
	<dev-embedded/sdcc-3.8.6"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	IUSE=""
	inherit git-r3 autotools
else
	SRC_URI="binary? ( https://sigrok.org/download/binary/${PN}/${PN}-bin-${PV}.tar.gz )
		!binary? ( https://sigrok.org/download/source/${PN}/${P}.tar.gz )"
	KEYWORDS="~amd64 ~x86"
	IUSE="binary"
	SDCC_DEPEND="!binary? ( ${SDCC_DEPEND} )"
fi

DESCRIPTION="Firmware for Cypress FX2 chips for use as simple logic analyzer hardware"
HOMEPAGE="https://sigrok.org/wiki/Fx2lafw"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}
	${SDCC_DEPEND}"

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
	else
		default
		# The binary & source dirs are slightly diff.
		use binary && S="${WORKDIR}/${PN}-bin-${PV}"
	fi
}

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
	eapply_user
}

src_install() {
	if [[ ${PV} != "9999" ]] && use binary ; then
		insinto /usr/share/sigrok-firmware
		doins *.fw
		dodoc ChangeLog NEWS README
	else
		default
	fi
}
