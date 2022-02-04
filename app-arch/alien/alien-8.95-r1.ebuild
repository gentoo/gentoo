# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module

DESCRIPTION="Converts between the rpm, dpkg, stampede slp, and slackware tgz file formats"
HOMEPAGE="https://sourceforge.net/projects/alien-pkg-convert"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 x86"
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

PATCHES=( "${FILESDIR}/${P}-tar-extensions.patch" )

src_prepare() {
	default
	sed -e s%'$(VARPREFIX)'%${D}% -e s%'$(PREFIX)'%${D}/usr%g \
		-i "${S}"/Makefile.PL || die "sed failed"
}
