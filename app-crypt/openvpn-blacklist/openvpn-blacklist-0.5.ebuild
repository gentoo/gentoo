# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="Detection of weak openvpn keys produced by certain debian versions in 2006-2008"
HOMEPAGE="http://packages.debian.org/sid/openvpn-blacklist"
SRC_URI="mirror://debian/pool/main/o/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=${PYTHON_DEPS}
REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_prepare() {
	python_fix_shebang openvpn-vulnkey
}

src_install() {
	dobin openvpn-vulnkey
	doman openvpn-vulnkey.1
	dodir /usr/share/openvpn-blacklist
	insinto /usr/share/openvpn-blacklist
	newins debian/blacklist.prefix blacklist.RSA-2048
	cut "${S}/blacklist.RSA-2048" -d ' ' -f 2 | cut -b13- | sort \
		>> "${D}/usr/share/openvpn-blacklist/blacklist.RSA-2048"|| die
}
