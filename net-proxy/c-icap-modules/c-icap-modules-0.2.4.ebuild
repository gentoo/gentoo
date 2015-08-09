# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib flag-o-matic

MY_PN=c_icap_modules #${PN/-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="URL blocklist and virus scanner for the C-ICAP server"
HOMEPAGE="http://c-icap.sourceforge.net/"
SRC_URI="mirror://sourceforge/c-icap/${PN}/0.2.x/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="berkdb clamav"

DEPEND="berkdb? ( sys-libs/db )
	clamav? ( app-antivirus/clamav )
	net-proxy/c-icap
	sys-libs/glibc
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# some void *** pointers get casted around and can be troublesome to
	# fix properly.
	append-flags -fno-strict-aliasing

	econf --sysconfdir=/etc/c-icap \
		--disable-dependency-tracking \
		--disable-maintainer-mode \
		--disable-static \
		$(use_with berkdb bdb) \
		$(use_with clamav)
}

src_compile() {
	emake LOGDIR="/var/log"
}

src_install() {
	dodir /etc/c-icap

	emake 	LOGDIR="/var/log" \
		DESTDIR="${D}" install

	find "${ED}" -name '*.la' -delete || die
}
