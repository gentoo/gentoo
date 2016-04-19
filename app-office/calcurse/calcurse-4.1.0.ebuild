# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils autotools multilib-minimal

DESCRIPTION="a text-based calendar and scheduling application"
HOMEPAGE="http://calcurse.org/"
SRC_URI="http://calcurse.org/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc ~ppc64"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	default

	epatch "${FILESDIR}"/"${P}-tinfo.patch"

	# Dubious tests.
	rm -v "${S}/test"/ical-00{2,4,6}.sh || die

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

src_compile() {
	multilib-minimal_src_compile
}

src_install() {
	multilib-minimal_src_install
}
