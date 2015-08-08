# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools base multilib

MY_P="${P/_rc/rc}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Advanced Linux Sound Architecture OSS compatibility layer"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/oss-lib/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="static-libs"

RDEPEND=">=media-libs/alsa-lib-${PV}"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/${PN}-1.0.12-hardened.patch" )

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	sed -i -e 's:\${exec_prefix}/\\$LIB/::' "${D}/usr/bin/aoss"
	find "${D}" -name "*.la" -delete
}
