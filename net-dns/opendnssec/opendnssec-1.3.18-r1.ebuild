# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P="${P/_}"
PKCS11_IUSE="+softhsm opensc external-hsm"
inherit autotools multilib user

DESCRIPTION="An open-source turn-key solution for DNSSEC"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://www.${PN}.org/files/source/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-auditor +curl debug doc eppclient mysql +signer +sqlite test ${PKCS11_IUSE}"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/perl
	dev-libs/libxml2
	dev-libs/libxslt
	net-libs/ldns
	curl? ( net-misc/curl )
	mysql? (
		virtual/mysql
		dev-perl/DBD-mysql
	)
	opensc? ( dev-libs/opensc )
	softhsm? ( dev-libs/softhsm:* )
	sqlite? (
		dev-db/sqlite:3
		dev-perl/DBD-SQLite
	)
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		app-text/trang
	)
"
# test? dev-util/cunit # Requires running test DB

REQUIRED_USE="
	^^ ( mysql sqlite )
	^^ ( softhsm opensc external-hsm )
	eppclient? ( curl )
"

PATCHES=(
	"${FILESDIR}/${PN}-fix-localstatedir.patch"
	"${FILESDIR}/${PN}-fix-run-dir.patch"
	"${FILESDIR}/${PN}-1.3.14-drop-privileges.patch"
	"${FILESDIR}/${PN}-1.3.14-use-system-trang.patch"
	"${FILESDIR}/${PN}-1.3.18-eppclient-curl-CVE-2012-5582.patch"
)

S="${WORKDIR}/${MY_P}"

DOCS=( MIGRATION NEWS )

check_pkcs11_setup() {
	# PKCS#11 HSM's are often only available with proprietary drivers not
	# available in portage tree.

	if use softhsm; then
		PKCS11_LIB=softhsm
		if has_version ">=dev-libs/softhsm-1.3.1"; then
			PKCS11_PATH=/usr/$(get_libdir)/softhsm/libsofthsm.so
		else
			PKCS11_PATH=/usr/$(get_libdir)/libsofthsm.so
		fi
		elog "Building with SoftHSM PKCS#11 library support."
	fi
	if use opensc; then
		PKCS11_LIB=opensc
		PKCS11_PATH=/usr/$(get_libdir)/opensc-pkcs11.so
		elog "Building with OpenSC PKCS#11 library support."
	fi
	if use external-hsm; then
		if [[ -n ${PKCS11_SCA6000} ]]; then
			PKCS11_LIB=sca6000
			PKCS11_PATH=${PKCS11_SCA6000}
		elif [[ -n ${PKCS11_ETOKEN} ]]; then
			PKCS11_LIB=etoken
			PKCS11_PATH=${PKCS11_ETOKEN}
		elif [[ -n ${PKCS11_NCIPHER} ]]; then
			PKCS11_LIB=ncipher
			PKCS11_PATH=${PKCS11_NCIPHER}
		elif [[ -n ${PKCS11_AEPKEYPER} ]]; then
			PKCS11_LIB=aepkeyper
			PKCS11_PATH=${PKCS11_AEPKEYPER}
		else
			ewarn "You enabled USE flag 'external-hsm' but did not specify a path to a PKCS#11"
			ewarn "library. To set a path, set one of the following environment variables:"
			ewarn "  for Sun Crypto Accelerator 6000, set: PKCS11_SCA6000=<path>"
			ewarn "  for Aladdin eToken, set: PKCS11_ETOKEN=<path>"
			ewarn "  for Thales/nCipher netHSM, set: PKCS11_NCIPHER=<path>"
			ewarn "  for AEP Keyper, set: PKCS11_AEPKEYPER=<path>"
			ewarn "Example:"
			ewarn "  PKCS11_ETOKEN=\"/opt/etoken/lib/libeTPkcs11.so\" emerge -pv opendnssec"
			ewarn "or store the variable into /etc/portage/make.conf"
			die "USE flag 'external-hsm' set but no PKCS#11 library path specified."
		fi
		elog "Building with external PKCS#11 library support ($PKCS11_LIB): ${PKCS11_PATH}"
	fi
}

pkg_pretend() {
	local i

	for i in eppclient mysql; do
		if use ${i}; then
			ewarn
			ewarn "Usage of ${i} is considered experimental."
			ewarn "Do not report bugs against this feature."
			ewarn
		fi
	done

	check_pkcs11_setup
}

pkg_setup() {
	enewgroup opendnssec
	enewuser opendnssec -1 -1 -1 opendnssec

	# pretend does not preserve variables so we need to run this once more
	check_pkcs11_setup
}

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	# $(use_with test cunit "${EPREFIX}/usr/") \
	econf \
		--without-cunit \
		--localstatedir="${EPREFIX}/var/" \
		--disable-static \
		--with-database-backend=$(use mysql && echo "mysql")$(use sqlite && echo "sqlite3") \
		--with-pkcs11-${PKCS11_LIB}=${PKCS11_PATH} \
		--disable-auditor \
		$(use_with curl) \
		$(use_enable debug timeshift) \
		$(use_enable eppclient) \
		$(use_enable signer)
}

src_compile() {
	default
	use doc && emake docs
}

src_install() {
	default

	# remove useless .la files
	find "${ED}" -name '*.la' -delete

	# Remove subversion tags from config files to avoid useless config updates
	sed -i \
		-e '/<!-- \$Id:/ d' \
		"${ED}"/etc/opendnssec/* || die

	# install update scripts
	insinto /usr/share/opendnssec
	use sqlite && doins enforcer/utils/migrate_keyshare_sqlite3.pl
	use mysql && doins enforcer/utils/migrate_keyshare_mysql.pl

	# fix permissions
	fowners root:opendnssec /etc/opendnssec
	fowners root:opendnssec /etc/opendnssec/{conf,kasp,zonelist,zonefetch}.xml
	use eppclient && fowners root:opendnssec /etc/opendnssec/eppclientd.conf

	fowners opendnssec:opendnssec /var/lib/opendnssec/{,signconf,unsigned,signed,tmp}

	# install conf/init script
	newinitd "${FILESDIR}"/opendnssec.initd-1.3.x opendnssec
	newconfd "${FILESDIR}"/opendnssec.confd-1.3.x opendnssec
	use auditor || sed -i 's/^CHECKCONFIG_BIN=.*/CHECKCONFIG_BIN=/' "${D}"/etc/conf.d/opendnssec
}

pkg_postinst() {
	if use softhsm; then
		elog "Please make sure that you create your softhsm database in a location writeable"
		elog "by the opendnssec user. You can set its location in /etc/softhsm.conf."
		elog "Suggested configuration is:"
		elog "    echo \"0:/var/lib/opendnssec/softhsm_slot0.db\" >> /etc/softhsm.conf"
		elog "    softhsm --init-token --slot 0 --label OpenDNSSEC"
		elog "    chown opendnssec:opendnssec /var/lib/opendnssec/softhsm_slot0.db"
	fi
	if use auditor; then
		ewarn
		ewarn "Please note that auditor support has been disabled in this version since it"
		ewarn "it depends on ruby 1.8 which has been removed from the portage tree."
		ewarn "USE=auditor is only provided for this warning but will not install the"
		ewarn "auditor anymore."
		ewarn
	fi
}
