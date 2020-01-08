# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="NXP i.MX firmware"
HOMEPAGE="https://www.timesys.com/"
SRC_URI="http://repository.timesys.com/buildsources/${PN:0:1}/${PN}/${P}/${P}.bin"
LICENSE="LA_OPT_BASE_LICENSE"
SLOT="0"
KEYWORDS="~arm"

S="${WORKDIR}/${P}/firmware"

src_unpack() {
	eval local $(grep -a -m1 "^filesizes=" "${DISTDIR}/${A}")
	tail -c"${filesizes}" "${DISTDIR}/${A}" > "${P}.tar.bz2" || die
	unpack "./${P}.tar.bz2"
}

src_prepare() {
	default
	find -name "*.mk" | xargs rm -v || die
}

src_install() {
	insinto /lib/firmware
	doins -r epdc sdma vpu
}
