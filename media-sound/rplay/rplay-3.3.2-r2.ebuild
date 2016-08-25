# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools user

DESCRIPTION="Play sounds on remote Unix systems without data transfer"
HOMEPAGE="http://rplay.doit.org/"
SRC_URI="${HOMEPAGE}dist/${P}.tar.gz
	mirror://debian/pool/main/r/${PN}/${PN}_${PV}-16.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-sound/gsm"
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}/debian/patches"
	"${FILESDIR}/${P}-built-in_function_exit-r1.patch"
)

pkg_setup() {
	enewgroup rplayd ""
	enewuser rplayd "" "" "" rplayd
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-rplayd-user=rplayd \
		--enable-rplayd-group=rplayd
}

src_install() {
	# This is borrowed from the old einstall helper, and is necessary
	# (at least some of variables).
	emake prefix="${ED}/usr" \
		datadir="${ED}/usr/share" \
		infodir="${ED}/usr/share/info" \
		localstatedir="${ED}/var/lib" \
		mandir="${ED}/usr/share/man" \
		sysconfdir="${ED}/etc" \
		install
}
