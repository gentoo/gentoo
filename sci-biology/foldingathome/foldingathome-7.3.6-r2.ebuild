# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit versionator user

MY_BASEURI="https://fah.stanford.edu/file-releases/public/release/fahclient"
MY_64B_URI="${MY_BASEURI}/centos-5.3-64bit/v$(get_version_component_range 1-2)/fahclient_${PV}-64bit-release.tar.bz2"
MY_32B_URI="${MY_BASEURI}/centos-5.5-32bit/v$(get_version_component_range 1-2)/fahclient_${PV}-32bit-release.tar.bz2"

DESCRIPTION="Folding@Home is a distributed computing project for protein folding"
HOMEPAGE="http://folding.stanford.edu/FAQ-SMP.html"
SRC_URI="x86? ( ${MY_32B_URI} )
	amd64? ( ${MY_64B_URI} )"

RESTRICT="mirror bindist strip"

LICENSE="FAH-EULA-2009 FAH-special-permission"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# Expressly listing all deps, as this is a binpkg and it is doubtful whether
# i.e. uclibc or clang can provide what is necessary at runtime
RDEPEND="app-arch/bzip2
	sys-devel/gcc
	sys-libs/glibc
	sys-libs/zlib"

S="${WORKDIR}"

I="opt/foldingathome"

QA_PREBUILT="${I}/*"

pkg_setup() {
	I="${EROOT}/${I}"
	einfo ""
	cat "${PORTDIR}"/licenses/FAH-special-permission
	einfo ""
}

src_install() {
	local myS="fahclient_${PV}-64bit-release"
	use x86 && myS="${myS//64bit/32bit}"
	exeinto "${I}"
	doexe "${FILESDIR}"/$(get_version_component_range 1-2)/initfolding
	doexe "${myS}"/{FAHClient,FAHCoreWrapper}
	newconfd "${FILESDIR}"/$(get_version_component_range 1-2)/folding-conf.d foldingathome
	newinitd "${FILESDIR}"/$(get_version_component_range 1-2)/fah-init foldingathome
}

pkg_preinst() {
	# the bash shell is important for "su -c" in init script
	enewuser foldingathome -1 /bin/bash /opt/foldingathome
}

pkg_postinst() {
	chown -R foldingathome:nogroup "${I}"
	einfo "To run Folding@home in the background at boot:"
	einfo "\trc-update add foldingathome default"
	einfo ""
	if [ ! -e "${I}"/config.xml ]; then
		elog "No configuration found -- please run ${I}/initfolding or"
		elog "emerge --config ${P} to configure your client and edit"
		elog "${EROOT}/etc/conf.d/foldingathome for options"
	fi
	einfo ""
	einfo "The original author encourages you to acquire a username and join team 36480."
	einfo "http://folding.stanford.edu/English/Download#ntoc2"
	einfo ""
}

pkg_postrm() {
	elog "Folding@home data files were not removed."
	elog "Remove them manually from ${I}"
}

pkg_config() {
	"${I}"/initfolding
}
