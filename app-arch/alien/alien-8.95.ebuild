# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Converts between the rpm, dpkg, stampede slp, and slackware tgz file formats"
HOMEPAGE="http://kitenet.net/programs/alien"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ppc ppc64 ~x86"
IUSE="+bzip2"

RDEPEND="
	app-arch/rpm
	app-arch/dpkg
	dev-util/debhelper
	>=app-arch/tar-1.14.91
	bzip2? (
		app-arch/bzip2
	)"

DEPEND="${RDEPEND}"

src_prepare() {
	sed -e s%'$(VARPREFIX)'%${D}% -e s%'$(PREFIX)'%${D}/usr%g \
		-i "${S}"/Makefile.PL || die "sed failed."
}
