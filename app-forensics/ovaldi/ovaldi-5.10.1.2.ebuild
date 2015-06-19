# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/ovaldi/ovaldi-5.10.1.2.ebuild,v 1.3 2014/11/02 08:08:56 swift Exp $

EAPI=3

inherit eutils

DESCRIPTION="Free implementation of OVAL"
HOMEPAGE="http://oval.mitre.org/language/interpreter.html"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap rpm selinux"

DEPEND="rpm? ( app-arch/rpm )
	dev-libs/libgcrypt:0
	dev-libs/libpcre
	dev-libs/xalan-c
	dev-libs/xerces-c
	ldap? ( net-nds/openldap )"
RDEPEND="${DEPEND}
	selinux? ( sys-libs/libselinux )"

S="${WORKDIR}/${P}-src"

src_prepare() {
	epatch "${FILESDIR}"/${P}-xerces3.patch
	epatch "${FILESDIR}"/${P}-strnicmp.patch
	epatch "${FILESDIR}"/${P}-missing-memory-header.patch
	if ! use ldap ; then
		einfo "Disabling LDAP probes"
		epatch "${FILESDIR}"/${P}-disable-ldap-probes.patch
		sed -i 's/-lldap//' project/linux/Makefile || die
		sed -i 's/.*LDAPProbe.h.*//' src/linux/ProbeFactory.h || die
		rm src/probes/independent/LDAPProbe.{cpp,h} || die
	fi

	# rpm probes support is build dependant only on the presence of the rpm binary
	if use rpm ; then
		#Same problems as bug 274679, so i do a local copy of the header and patch it
		cp /usr/include/rpm/rpmdb.h src/probes/linux/ || die
		epatch "${FILESDIR}"/use_local_rpmdb.patch
		epatch "${FILESDIR}"/rpmdb.patch
	else
		einfo "Disabling rpm probes"
		sed -i 's/^PACKAGE_RPM/#PACKAGE_RPM/' project/linux/Makefile || die
	fi
	# same thing for dpkg, but package dpkg is not sufficient, needs app-arch/apt-pkg that is not on tree
	einfo "Disabling dpkg probes"
	sed -i 's/^PACKAGE_DPKG/#PACKAGE_DPKG/' project/linux/Makefile || die

	#Disabling SELinux support
	if ! use selinux ; then
		rm src/probes/linux/SelinuxSecurityContextProbe.cpp || die
		rm src/probes/linux/SelinuxBooleanProbe.cpp || die
		rm src/probes/linux/SelinuxBooleanProbe.h || die
		epatch "${FILESDIR}"/${P}-disable-selinux-probes.patch
	else
		epatch "${FILESDIR}"/${P}-add-selinux-libs.patch
	fi
}

src_compile () {
	emake -C project/linux || die
}

src_install () {
	# no make install in Makefile
	dosbin project/linux/Release/ovaldi project/linux/ovaldi.sh || die
	dodir /var/log/${PN} || die
	insinto /usr/share/${PN}
	doins xml/* || die
	dodoc docs/{README.txt,version.txt} || die
	doman docs/ovaldi.1 || die
}
