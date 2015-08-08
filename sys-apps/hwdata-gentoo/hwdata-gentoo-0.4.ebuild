# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Data for the hwsetup program"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://wolf31o2.org/sources/hwdata/${P}.tar.bz2"
HOMEPAGE="http://wolf31o2.org"

IUSE="opengl binary-drivers"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="!sys-apps/hwdata-redhat"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-openchrome.patch

	if use x86 || use amd64
	then
		if use opengl && use binary-drivers
		then
			continue
		else
			sed -e 's/DRIVER fglrx/DRIVER radeon/' \
				-e 's/DRIVER nvidia/DRIVER nv/' \
				-i "${S}"/Cards || die
		fi
	fi
}

src_install() {
	dodoc ChangeLog check-cards
	insinto /usr/share/hwdata
	doins Cards MonitorsDB pcitable blacklist
}
