# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PV=${PV/_p/-}

inherit bash-completion-r1 eutils

DESCRIPTION="Screen capture utility using imlib2 library"
HOMEPAGE="http://scrot.sourcearchive.com/"
SRC_URI="http://http.debian.net/debian/pool/main/s/${PN}/${PN}_0.8.orig.tar.gz
		http://http.debian.net/debian/pool/main/s/${PN}/${PN}_${MY_PV}.debian.tar.gz"

LICENSE="feh LGPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/imlib2-1.0.3
	>=media-libs/giblib-1.2.3"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-0.8

src_prepare() {
	local d=${WORKDIR}/debian/patches
	EPATCH_SOURCE=${d} epatch $(<"${d}"/series)
}

src_install() {
	emake DESTDIR="${D}" install
	rm -r "${D}"/usr/doc
	dodoc AUTHORS ChangeLog

	newbashcomp "${FILESDIR}"/${PN}.bash-completion ${PN}
}
