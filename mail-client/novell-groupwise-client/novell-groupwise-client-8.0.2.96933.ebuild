# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/novell-groupwise-client/novell-groupwise-client-8.0.2.96933.ebuild,v 1.9 2015/04/09 10:28:02 dilfridge Exp $

EAPI=5

inherit eutils rpm multilib versionator

MY_PV=$(replace_version_separator 3 '-')
MY_P="${P/_p/-}"
S="${WORKDIR}/${PN}-${MY_PV}"

DESCRIPTION="Novell Groupwise Client for Linux"
HOMEPAGE="http://www.novell.com/products/groupwise/"
SRC_URI="gw802_hp3_client_linux_multi.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	sys-libs/libstdc++-v3
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXau-1.0.8[abi_x86_32(-)]
	>=x11-libs/libXcursor-1.1.14[abi_x86_32(-)]
	>=x11-libs/libXdmcp-1.1.1-r1[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.3[abi_x86_32(-)]
	>=x11-libs/libXfixes-5.0.1[abi_x86_32(-)]
	>=x11-libs/libXi-1.7.4[abi_x86_32(-)]
	>=x11-libs/libXrender-0.9.8[abi_x86_32(-)]
	>=x11-libs/libXtst-1.2.2[abi_x86_32(-)]
	>=x11-libs/libxcb-1.11-r1[abi_x86_32(-)]
	x11-libs/motif:2.2[abi_x86_32(-)]
	>=media-libs/alsa-lib-1.0.28[abi_x86_32(-)]
	>=media-libs/freetype-2.5.5[abi_x86_32(-)]
"

RESTRICT="binchecks fetch mirror strip"

src_unpack() {
	unpack ${A}
	mkdir -p "${WORKDIR}"/${PN}-${MY_PV} || die
	cd ${PN}-${MY_PV} || die
	rpm_unpack ./../gw${MY_PV}_client_linux_multi/${PN}-${MY_PV}.i586.rpm
}

src_compile() { :; }

src_install() {
	JRE_DIR="${WORKDIR}"/${PN}-${MY_PV}/opt/novell/groupwise/client/java;

	# Undo Sun's funny-business with packed .jar's
	for i in $JRE_DIR/lib/*.pack; do
		i_b=`echo $i | sed 's/\.pack$//'`;
		einfo "Unpacking `basename $i` -> `basename $i_b.jar`";
		$JRE_DIR/bin/unpack200 $i $i_b.jar || die "Unpack failed";
	done;

	domenu "${WORKDIR}"/${PN}-${MY_PV}/opt/novell/groupwise/client/gwclient.desktop

	mv "${WORKDIR}"/${PN}-${MY_PV}/opt "${D}"/ || die "mv opt failed"

	dodir /opt/bin
	dosym /opt/novell/groupwise/client/bin/groupwise /opt/bin/groupwise
}

pkg_nofetch() {
	einfo "You can obtain an evaluation version of the Groupwise client at"
	einfo "${HOMEPAGE} - please download ${SRC_URI}"
	einfo "and place it in ${DISTDIR}. Alternatively request the file"
	einfo "from the Groupwise server provider of your organization."
	einfo "Note that the client is useless without a server account."
}
