# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils rpm

REL="10_3/2.6.22.13_0.3"

DESCRIPTION="AVM DSL Assistant for autodetecting DSL values (VPI, VCI, VPP) for 'fcdsl' based cards"
HOMEPAGE="http://opensuse.foehr-it.de/"
SRC_URI="x86? ( http://opensuse.foehr-it.de/rpms/${REL}/32bit/${PN}-1.0-1.i586.rpm )
	amd64? ( http://opensuse.foehr-it.de/rpms/${REL}/64bit/${PN}-1.0-1.x86_64.rpm )"

LICENSE="AVM-FC"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="unicode"

DEPEND="unicode? ( virtual/libiconv )"
RDEPEND="net-dialup/capi4k-utils"

RESTRICT="mirror strip test"

S="${WORKDIR}"

src_unpack() {
	rpm_src_unpack ${A}
	cd "${S}"

	# convert 'latin1' to 'utf8'
	if use unicode; then
		for i in etc/drdsl/drdsl.ini; do
			echo ">>> Converting '${i##*/}' to UTF-8"
			iconv -f LATIN1 -t UTF8 -o "${i}~" "${i}" && mv -f "${i}~" "${i}" || rm -f "${i}~"
		done
	fi
}

src_install() {
	into /
	dosbin sbin/drdsl
	insinto /etc/drdsl
	doins etc/drdsl/drdsl.ini
	dodoc "${FILESDIR}"/README
}
