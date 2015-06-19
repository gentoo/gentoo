# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/opendylan-bin/opendylan-bin-2011.1.ebuild,v 1.3 2012/08/21 08:26:59 patrick Exp $
EAPI=4

DESCRIPTION="OpenDylan language runtime environment (prebuilt)"

MY_PN="opendylan"
MY_P="${MY_PN}-${PV}"
HOMEPAGE="http://opendylan.org"
SRC_URI="amd64? ( http://opendylan.org/downloads/${MY_PN}/${PV}/${MY_P}-x86_64-linux.tar.bz2 )
	x86? ( http://opendylan.org/downloads/${MY_PN}/${PV}/${MY_P}-x86-linux.tar.bz2 )"
LICENSE="Opendylan"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND="dev-libs/boehm-gc"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() { :; }
src_compile() { :; }

src_install() {
	# this is a precompiled tarball
	mkdir -p "${D}/opt/${MY_P}"
	cp -ar "${S}"/* "${D}/opt/${MY_P}" || die "Failed to copy stuff"
	mkdir -p "${D}/etc/env.d/opendylan"
	echo "export PATH=/opt/opendylan-2011.1/bin:\$PATH" > "${D}/etc/env.d/opendylan/99-opendylan-bin" || die "Failed to add env settings"
}
