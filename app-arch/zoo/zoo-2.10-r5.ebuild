# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Manipulate archives of files in compressed form"
HOMEPAGE="https://packages.debian.org/sid/utils/zoo"
SRC_URI="http://http.debian.net/debian/pool/main/z/${PN}/${PN}_${PV}.orig.tar.gz
	http://http.debian.net/debian/pool/main/z/${PN}/${PN}_${PV}-28.debian.tar.xz"
S="${WORKDIR}"/${P}.orig

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

PATCHES=(
	"${WORKDIR}"/debian/patches/.
	"${FILESDIR}"/${P}-gentoo-fbsd-r1.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake linux
}

src_install() {
	dobin zoo fiz
	doman zoo.1 fiz.1
}
