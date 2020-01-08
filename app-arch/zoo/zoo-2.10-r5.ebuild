# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Manipulate archives of files in compressed form"
HOMEPAGE="https://packages.debian.org/sid/utils/zoo"
SRC_URI="http://http.debian.net/debian/pool/main/z/${PN}/${PN}_${PV}.orig.tar.gz
	http://http.debian.net/debian/pool/main/z/${PN}/${PN}_${PV}-28.debian.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE=""

S="${WORKDIR}/${P}.orig"

PATCHES=( "${FILESDIR}/zoo-2.10-gentoo-fbsd-r1.patch" )

src_prepare() {
	eapply "${WORKDIR}"/debian/patches/*.patch
	default
}

src_compile() {
	emake CC="$(tc-getCC)" linux
}

src_install() {
	dobin zoo fiz
	doman zoo.1 fiz.1
}
