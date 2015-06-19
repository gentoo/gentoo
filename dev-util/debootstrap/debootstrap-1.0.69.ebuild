# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/debootstrap/debootstrap-1.0.69.ebuild,v 1.1 2015/05/19 04:16:05 jer Exp $

EAPI=5
inherit eutils

DESCRIPTION="Debian/Ubuntu bootstrap scripts"
HOMEPAGE="http://packages.qa.debian.org/d/debootstrap.html"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.gz
	mirror://gentoo/devices.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	app-arch/dpkg
	net-misc/wget
	sys-devel/binutils
"

DOCS=( TODO debian/changelog )

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
	cp "${DISTDIR}"/devices.tar.gz "${S}"
}

src_compile() {
	return
}

src_install() {
	default
	doman debootstrap.8
}

pkg_postinst() {
	if ! has_version ${CATEGORY}/${PN} && ! has_version app-crypt/gnupg; then
		elog "To check Release files against a keyring"
		elog " (--keyring=K), please install app-crypt/gnupg."
	fi
}
