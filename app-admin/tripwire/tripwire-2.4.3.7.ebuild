# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Open Source File Integrity Checker and IDS"
HOMEPAGE="http://www.tripwire.org/"
SRC_URI="https://github.com/Tripwire/tripwire-open-source/archive/${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="libressl selinux ssl static +tools"

DEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
RDEPEND="${DEPEND}
	virtual/cron
	virtual/mta
	selinux? ( sec-policy/selinux-tripwire )
"
PDEPEND="tools? ( app-admin/mktwpol )"

S="${WORKDIR}/tripwire-open-source-${PV}"

src_prepare() {
	default
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
