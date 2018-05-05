# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib

DESCRIPTION="eselect module for metasploit"
HOMEPAGE="http://www.pentoo.ch/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="app-admin/eselect
	!<net-analyzer/metasploit-4.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
	cp "${FILESDIR}"/91metasploit 91metasploit || die
	cp "${FILESDIR}"/msfloader-${PV} msfloader-${PV} || die

	sed -i -e "s/@LIBDIR@/$(get_libdir)/g" 91metasploit || die
	sed -i -e "s/@LIBDIR@/$(get_libdir)/g" msfloader-${PV} || die
}

src_install() {
	#force to use the outdated bundled version of metasm
	doenvd 91metasploit

	newinitd "${FILESDIR}"/msfrpcd.initd msfrpcd
	newconfd "${FILESDIR}"/msfrpcd.confd msfrpcd

	insinto /usr/share/eselect/modules
	newins "${FILESDIR}/metasploit.eselect-0.13" metasploit.eselect

	newbin msfloader-${PV} msfloader
}

pkg_postinst() {
	"${EROOT}"/usr/bin/eselect metasploit set --use-old 1
	elog "To switch between installed slots, execute as root:"
	elog " # eselect metasploit set [slot number]"
}
