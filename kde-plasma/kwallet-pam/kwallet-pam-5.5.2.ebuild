# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_AUTODEPS="false"
inherit kde5 multilib

DESCRIPTION="KWallet PAM module to not enter password again"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	dev-libs/libgcrypt:0=
	virtual/pam
"
RDEPEND="${DEPEND}
	net-misc/socat
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="/$(get_libdir)"
	)

	kde5_src_configure
}
