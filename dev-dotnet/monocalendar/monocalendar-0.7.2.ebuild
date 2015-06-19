# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/monocalendar/monocalendar-0.7.2.ebuild,v 1.4 2012/06/04 07:10:44 zmedico Exp $

inherit mono eutils multilib

S="${WORKDIR}/MonoCalendar"

DESCRIPTION="iCal clone for .NET"
HOMEPAGE="http://www.monocalendar.com/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=dev-lang/mono-1.2.1"
RDEPEND="${DEPEND}"

src_compile() {
	cd "${S}"/bin/Release/

	emake || die "emake failed"
}

src_install() {
	dodir /usr/$(get_libdir)/${PN}
	insinto /usr/$(get_libdir)/${PN}

	doins bin/Release/*dll
	doins bin/Release/*.exe

	make_wrapper monocalendar "mono /usr/$(get_libdir)/${PN}/MonoCalendar.exe"
}
