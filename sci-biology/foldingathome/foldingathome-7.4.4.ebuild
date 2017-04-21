# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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

LICENSE="FAH-EULA-2014 FAH-special-permission"
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
	einfo ""
	einfo "Special permission is hereby granted to the Gentoo project to provide an"
	einfo "automated installer package which downloads and installs the Folding@home client"
	einfo "software. Permission is also granted for future Gentoo installer packages on the"
	einfo "condition that they continue to adhere to all of the terms of the accompanying"
	einfo "Folding@home license agreements and display this notice."
	einfo "-- Vijay S. Pande, Stanford University, 07 May 2013"
	einfo ""
	einfo "(ref: http://foldingforum.org/viewtopic.php?f=16&t=22524&p=241992#p241992 )"
	einfo ""
}

src_install() {
	local myS="fahclient_${PV}-64bit-release"
	use x86 && myS="${myS//64bit/32bit}"
	exeinto ${I}
	doexe "${FILESDIR}"/7.3/initfolding
	doexe "${myS}"/{FAHClient,FAHCoreWrapper}
	newconfd "${FILESDIR}"/7.3/folding-conf.d foldingathome
	newinitd "${FILESDIR}"/7.3/fah-init foldingathome
}

pkg_preinst() {
	# the bash shell is important for "su -c" in init script
	enewuser foldingathome -1 /bin/bash "${EPREFIX}"/opt/foldingathome
}

pkg_postinst() {
	chown -R foldingathome:nogroup "${EPREFIX}"/${I}
	einfo "To run Folding@home in the background at boot (with openrc):"
	einfo "\trc-update add foldingathome default"
	einfo ""
	if [ ! -e "${EPREFIX}"/${I}/config.xml ]; then
		elog "No configuration found -- please run ${I}/initfolding or"
		elog "emerge --config ${P} to configure your client and edit"
		elog "${EPREFIX}/etc/conf.d/foldingathome for options"
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
	"${EPREFIX}"/${I}/initfolding
}
