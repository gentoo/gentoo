# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit desktop rpm multilib versionator

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

DEPEND=">=dev-util/patchelf-0.9"
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
	>=x11-libs/motif-2.3.7:0[abi_x86_32(-),motif22-compatibility]
	>=media-libs/alsa-lib-1.0.28[abi_x86_32(-)]
	>=media-libs/freetype-2.5.5[abi_x86_32(-)]
"

RESTRICT="fetch mirror strip"

# we might as well list all files in all QA variables...
QA_PREBUILT="*"

src_unpack() {
	unpack ${A}
	mkdir -p "${WORKDIR}"/${PN}-${MY_PV} || die
	cd ${PN}-${MY_PV} || die
	rpm_unpack ./../gw${MY_PV}_client_linux_multi/${PN}-${MY_PV}.i586.rpm
}

src_prepare() {
	# Binary patch soname for Motif
	cd opt/novell/groupwise/client/lib || die
	patchelf --replace-needed libXm.so.{3,4} libos_xwin.so || die
	patchelf --replace-needed libXm.so.{3,4} libsc_xp.so || die
}

src_compile() { :; }

src_install() {
	JRE_DIR="${WORKDIR}"/${PN}-${MY_PV}/opt/novell/groupwise/client/java;

	# Undo Sun's funny-business with packed .jar's
	for i in ${JRE_DIR}/lib/*.pack; do
		i_b=`echo ${i} | sed 's/\.pack$//'`;
		einfo "Unpacking `basename ${i}` -> `basename ${i_b}.jar`";
		${JRE_DIR}/bin/unpack200 ${i} ${i_b}.jar || die "Unpack failed";
	done;

	domenu "${WORKDIR}"/${PN}-${MY_PV}/opt/novell/groupwise/client/gwclient.desktop

	mv "${WORKDIR}"/${PN}-${MY_PV}/opt "${D}"/ || die "mv opt failed"

	dodir /opt/bin
	dosym ../novell/groupwise/client/bin/groupwise /opt/bin/groupwise
}

pkg_nofetch() {
	einfo "You can obtain an evaluation version of the Groupwise client at"
	einfo "${HOMEPAGE} - please download ${SRC_URI}"
	einfo "and place it into your DISTDIR directory. Alternatively request"
	einfo "the file from the Groupwise server provider of your organization."
	einfo "Note that the client is useless without a server account."
}
