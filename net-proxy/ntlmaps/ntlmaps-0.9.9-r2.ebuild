# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils user

DESCRIPTION="NTLM proxy Authentication against MS proxy/web server"
HOMEPAGE="http://ntlmaps.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 x86"
IUSE=""

DEPEND="dev-lang/python"

pkg_setup() {
	enewgroup ntlmaps
	enewuser ntlmaps -1 -1 -1 ntlmaps
}

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch"

	sed -i -e 's/\r//' lib/*.py server.cfg *.txt doc/*.{txt,htm} || die 'Failed to convert line endings.'
}

src_install() {
	exeinto /usr/bin
	newexe main.py ntlmaps
	insinto /usr/lib/ntlmaps
	doins lib/*

	dodoc *.txt doc/*.txt
	dohtml doc/*

	insopts -m0640 -g ntlmaps
	insinto /etc/ntlmaps
	doins server.cfg
	newinitd "${FILESDIR}/ntlmaps.init" ntlmaps

	diropts -m 0770 -g ntlmaps
	keepdir /var/log/ntlmaps
}

pkg_preinst() {
	#Remove the following lines sometime in December 2005
	#Their purpose is to fix security bug #107766
	if [ -f "${ROOT}/etc/ntlmaps/server.cfg" ]; then
		chmod 0640 "${ROOT}/etc/ntlmaps/server.cfg"
		chgrp ntlmaps "${ROOT}/etc/ntlmaps/server.cfg"
	fi
}

pkg_prerm() {
	einfo "Removing python compiled bytecode"
	rm -f "${ROOT}"/usr/lib/ntlmaps/*.py?
}
