# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/arp-warp-bin/arp-warp-bin-7.5.ebuild,v 1.1 2015/03/11 13:31:52 jlec Exp $

EAPI=5

inherit eutils prefix

MY_P="arp_warp_${PV}"

DESCRIPTION="Improvement and interpretation of crystallographic electron density maps"
SRC_URI="${MY_P}.tar.gz"
HOMEPAGE="http://www.embl-hamburg.de/ARP/"

LICENSE="ArpWarp"
SLOT="0"
KEYWORDS="-* amd64 x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_sse2"

REQUIRED_USE="cpu_flags_x86_sse2"

RDEPEND="
	app-shells/tcsh
	sci-chemistry/refmac
	virtual/awk
	virtual/jre
	virtual/opengl
	x11-libs/libX11"
DEPEND=""

RESTRICT="fetch"

S="${WORKDIR}/${MY_P}"

QA_PREBUILT="opt/arp-warp-bin/bin/*"

pkg_nofetch(){
	elog "Fill out the form at http://www.embl-hamburg.de/ARP/"
	elog "and place ${A} in ${DISTDIR}"
}

src_prepare() {
	epatch "${FILESDIR}"/7.3-setup.patch
	eprefixify "${S}"/share/arpwarp_setup_base.*

	sed -e '/exit/d' -i "${S}"/share/arpwarp_setup_base.* || die
}

src_install(){
	m_type=$(uname -m)
	os_type=$(uname)

	exeinto /opt/${PN}/bin/bin-${m_type}-${os_type}
	doexe "${S}"/bin/bin-${m_type}-${os_type}/* "${S}"/share/*{pl,sh}

	insinto /opt/${PN}/bin/bin-${m_type}-${os_type}
	doins "${S}"/share/*{gif,bmp,XYZ,bash,csh,dat,lib,tbl,llh,prm}

	insinto /etc/profile.d/
	newins "${S}"/share/arpwarp_setup_base.csh 90arpwarp_setup.csh
	newins "${S}"/share/arpwarp_setup_base.bash 90arpwarp_setup.sh

	dodoc "${S}"/README manual/UserGuide${PV}.pdf
	dohtml -r "${S}"/manual/html/*
}

pkg_postinst(){
	testcommand=$(echo 3 2 | awk '{printf"%3.1f",$1/$2}')
	if [ $testcommand == "1,5" ];then
	  ewarn "*** ERROR ***"
	  ewarn "   3/2=" $testcommand
	  ewarn "Invalid decimal separator (must be ".")"
	  ewarn "You need to set this correctly!!!"
	  echo
	  ewarn "One way of setting the decimal separator is:"
	  ewarn "setenv LC_NUMERIC C' in your .cshrc file"
	  ewarn "\tor"
	  ewarn "export LC_NUMERIC=C' in your .bashrc file"
	  ewarn "Otherwise please consult your system manager"
	fi
}
