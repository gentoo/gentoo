# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Play sounds on remote Unix systems without data transfer"
HOMEPAGE="http://rplay.doit.org/"
SRC_URI="
	http://rplay.doit.org/dist/${PN}-$(ver_cut 1-3).tar.gz
	mirror://debian/pool/main/r/${PN}/${PN}_$(ver_cut 1-3)-$(ver_cut 5).debian.tar.xz
"
S="${WORKDIR}"/${PN}-$(ver_cut 1-3)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	acct-group/rplayd
	acct-user/rplayd
	media-sound/gsm
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}"/debian/patches
	"${FILESDIR}"/${PN}-$(ver_cut 1-3)-built-in_function_exit-r1.patch
)

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

	find "${ED}" -name '*.la' -delete || die
}
