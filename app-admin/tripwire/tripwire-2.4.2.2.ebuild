# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/tripwire/tripwire-2.4.2.2.ebuild,v 1.7 2013/09/03 15:01:36 nimiux Exp $

EAPI=5

inherit autotools eutils flag-o-matic

DESCRIPTION="Open Source File Integrity Checker and IDS"
HOMEPAGE="http://www.tripwire.org/"
SRC_URI="mirror://sourceforge/tripwire/tripwire-${PV}-src.tar.bz2
	mirror://gentoo/twpol.txt.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="ssl static"

DEPEND="sys-devel/automake
	sys-devel/autoconf
	ssl? ( dev-libs/openssl )"
RDEPEND="virtual/cron
	virtual/mta
	ssl? ( dev-libs/openssl )"

S="${WORKDIR}"/tripwire-"${PV}"-src

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-fix-configure.patch
	epatch "${FILESDIR}"/"${P}"-buildnum.patch

	eautoreconf
}

src_configure() {
	# tripwire can be sensitive to compiler optimisation.
	# see #32613, #45823, and others.
	# 	-taviso@gentoo.org
	strip-flags
	append-cppflags -DCONFIG_DIR='"\"/etc/tripwire\""' -fno-strict-aliasing
	chmod +x configure || die
	econf $(use_enable ssl openssl) $(use_enable static)
}

src_install() {
	dosbin "${S}"/bin/{siggen,tripwire,twadmin,twprint}
	doman "${S}"/man/man{4/*.4,5/*.5,8/*.8}
	dodir /etc/tripwire /var/lib/tripwire{,/report}
	keepdir /var/lib/tripwire{,/report}

	exeinto /etc/cron.daily
	doexe "${FILESDIR}"/tripwire.cron

	dodoc ChangeLog policy/policyguide.txt TRADEMARK \
		"${FILESDIR}"/tripwire.txt

	insinto /etc/tripwire
	doins "${WORKDIR}"/twpol.txt "${FILESDIR}"/twcfg.txt

	exeinto /etc/tripwire
	doexe "${FILESDIR}"/twinstall.sh

	fperms 755 /etc/tripwire/twinstall.sh /etc/cron.daily/tripwire.cron
}

pkg_postinst() {
	elog "After installing this package, you should check the policy"
	elog "file (twpol.txt) shipped with the package to see if it"
	elog "suits your needs, and modify it accordingly."
	elog
	elog "Check bug #34662 to find a bash script which generates a"
	elog "policy file from the Gentoo packages installed in your system."
	elog
	elog "Once the policy file is ready, you can run the"
	elog "\"/etc/tripwire/twinstall.sh\" script to generate the "
	elog "cryptographic keys, and \"tripwire --init\" to initialize"
	elog "the Tripwire's database."
	elog
	elog "A quickstart guide is included with the documentation."
	elog
}
