# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

SDCC_DEPEND=">=dev-embedded/sdcc-3.4.0[device-lib(+),mcs51(+),sdcpp(+)]"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3 autotools
else
	SRC_URI="
		binary? ( https://sigrok.org/download/binary/${PN}/${PN}-bin-${PV}.tar.gz )
		!binary? (
			https://sigrok.org/download/source/${PN}/${P}.tar.gz
			https://dev.gentoo.org/~ceamac/${CATEGORY}/${PN}/${P}-update-syntax.patch.xz
		)
	"
	KEYWORDS="~amd64 ~x86"
	IUSE="binary"
	SDCC_DEPEND="!binary? ( ${SDCC_DEPEND} )"
fi

DESCRIPTION="Firmware for Cypress FX2 chips for use as simple logic analyzer hardware"
HOMEPAGE="https://sigrok.org/wiki/Fx2lafw"

LICENSE="GPL-2+"
SLOT="0"

DEPEND="${SDCC_DEPEND}"

PATCHES=()

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
	else
		default
		if use binary; then
			# The binary & source dirs are slightly diff.
			S="${WORKDIR}/${PN}-bin-${PV}"
		else
			PATCHES+=(
				"${WORKDIR}"/${P}-update-syntax.patch
			)
		fi
	fi
}

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
	default
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
