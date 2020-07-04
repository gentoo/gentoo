# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils mono

DESCRIPTION="iCal clone for .NET"
HOMEPAGE="http://www.monocalendar.com/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.gz"
S="${WORKDIR}/MonoCalendar"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=dev-lang/mono-1.2.1"
RDEPEND="${DEPEND}"

src_compile() {
	emake -C bin/Release
}

src_install() {
	exeinto /usr/$(get_libdir)/${PN}
	doexe bin/Release/*dll
	doexe bin/Release/*.exe

	make_wrapper monocalendar "mono /usr/$(get_libdir)/${PN}/MonoCalendar.exe"
}
