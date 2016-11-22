# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit flag-o-matic toolchain-funcs versionator eutils udev

MY_PV="$(replace_version_separator 2 -)"

DESCRIPTION="Administrative interface for the grsecurity Role Based Access Control system"
HOMEPAGE="http://www.grsecurity.net/"
SRC_URI="https://dev.gentoo.org/~blueness/hardened-sources/gradm/${PN}-${MY_PV}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="pam"

RDEPEND=""
DEPEND="
	sys-devel/bison
	sys-devel/flex
	pam? ( virtual/pam )"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/respect-gentoo-env-r3.patch
	sed -i -e "s:/lib/udev:$(get_udevdir):" Makefile || die
	eapply_user
}

src_compile() {
	local target
	use pam || target="nopam"

	emake ${target} CC="$(tc-getCC)" OPT_FLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	fperms 711 /sbin/gradm
}

pkg_postinst() {
	ewarn
	ewarn "Be sure to set a password with 'gradm -P' before enabling learning mode."
	ewarn
}
