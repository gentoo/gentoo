# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/tripwire/tripwire-2.4.2.2-r2.ebuild,v 1.5 2014/08/03 18:34:45 ago Exp $

EAPI=5

inherit autotools eutils flag-o-matic

DESCRIPTION="Open Source File Integrity Checker and IDS"
HOMEPAGE="http://www.tripwire.org/"
SRC_URI="mirror://sourceforge/tripwire/tripwire-${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="ssl static +tools"

DEPEND="sys-devel/automake
	sys-devel/autoconf
	ssl? ( dev-libs/openssl )"
RDEPEND="virtual/cron
	virtual/mta
	ssl? ( dev-libs/openssl )"
PDEPEND="tools? ( app-admin/mktwpol )"

S="${WORKDIR}"/tripwire-"${PV}"-src

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-fix-configure.patch
	epatch "${FILESDIR}"/"${P}"-buildnum.patch
	epatch "${FILESDIR}"/"${P}"-gcc-4.7.patch
	epatch "${FILESDIR}"/"${PN}"-twpol-GENERIC.patch

	eautoreconf
}

src_configure() {
	# tripwire can be sensitive to compiler optimisation.
	# see #32613, #45823, and others.
	# 	-taviso@gentoo.org
	strip-flags
	append-cppflags -DCONFIG_DIR='"\"/etc/tripwire\""' -fno-strict-aliasing
	econf $(use_enable ssl openssl) $(use_enable static)
}

src_install() {
	dosbin "${S}"/bin/{siggen,tripwire,twadmin,twprint}
	doman "${S}"/man/man{4/*.4,5/*.5,8/*.8}
	dodir /etc/tripwire /var/lib/tripwire{,/report}
	keepdir /var/lib/tripwire{,/report}

	exeinto /etc/cron.daily
	doexe "${FILESDIR}"/tripwire

	dodoc ChangeLog policy/policyguide.txt TRADEMARK \
		"${FILESDIR}"/tripwire.txt

	insinto /etc/tripwire
	doins "${FILESDIR}"/twcfg.txt policy/twpol-GENERIC.txt

	fperms 750 /etc/cron.daily/tripwire
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Tripwire needs to be configured before its first run. You can"
		elog "do this by manually editing the twpol-GENERIC.txt file shipped with"
		elog "the package to suit your needs. A quickstart guide is provided"
		elog "in tripwire.txt file to help you with this."
		elog "To configure tripwire automatically, you can use the twsetup.sh"
		elog "script provided by the app-admin/mktwpol package. This package is"
		elog "installed for you by the \"tools\" USE flag (which is enabled by"
		elog "default."
else
		elog "Maintenance of tripwire policy files as packages are added"
		elog "and deleted from your system can be automated by the mktwpol.sh"
		elog "script provided by the app-admin/mktwpol package. This package"
		elog "is installed for you if you append \"tools\" to your USE flags"
	fi
}
