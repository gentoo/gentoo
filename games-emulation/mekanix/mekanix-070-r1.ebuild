# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="SG-1000, SC-3000, SF-7000, SSC, SMS, GG, COLECO, and OMV emulator"
HOMEPAGE="https://www.smspower.org/meka/"
SRC_URI="https://www.smspower.org/meka/releases/${PN}${PV}.tgz"

LICENSE="mekanix"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="strip"
IUSE=""

RDEPEND="media-libs/libpng
	x11-libs/libXpm"

S=${WORKDIR}/${PN}

# file verfies that it's an elf, not win32, binary:
QA_PREBUILT="opt/${PN}/meka.exe"

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins *
	fperms a+x "${dir}/meka.exe"
	make_wrapper mekanix ./meka.exe "${dir}"
}
