# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools user

DESCRIPTION="Play sounds on remote Unix systems without data transfer"
HOMEPAGE="http://rplay.doit.org/"
SRC_URI="${HOMEPAGE}dist/${P}.tar.gz
	mirror://debian/pool/main/r/${PN}/${PN}_${PV}-16.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc x86"
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
	mv configure.{in,ac} || die
	mv rx/configure.{in,ac} || die
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
		libdir="${ED}/usr/$(get_libdir)" \
		datadir="${ED}/usr/share" \
		infodir="${ED}/usr/share/info" \
		localstatedir="${ED}/var/lib" \
		mandir="${ED}/usr/share/man" \
		sysconfdir="${ED}/etc" \
		install
}
