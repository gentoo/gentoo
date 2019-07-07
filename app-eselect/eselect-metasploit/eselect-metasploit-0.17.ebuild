# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

DESCRIPTION="eselect module for metasploit"
HOMEPAGE="https://www.pentoo.ch/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="app-admin/eselect
	!<net-analyzer/metasploit-4.6"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install() {
	#force to use the outdated bundled version of metasm
	doenvd "${FILESDIR}"/91metasploit

	newinitd "${FILESDIR}"/msfrpcd.initd msfrpcd
	newconfd "${FILESDIR}"/msfrpcd.confd msfrpcd

	insinto /usr/share/eselect/modules
	newins "${FILESDIR}/metasploit.eselect-0.17" metasploit.eselect

	newbin "${FILESDIR}"/msfloader-0.16 msfloader
}

pkg_postinst() {
	"${EROOT}"/usr/bin/eselect metasploit set --use-old 1
	elog "To switch between installed slots, execute as root:"
	elog " # eselect metasploit set [slot number]"
}
