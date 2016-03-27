# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic multilib toolchain-funcs user

ETHZ_PV="1.0"
LDAP_PV="1.0"
LDAPS_PV="1.0"
SILOMAIL_PV="1.0"
MODULES_PV="0.9.0"

DESCRIPTION="SIP Express Router"
HOMEPAGE="http://www.iptel.org/ser"
SRC_URI="
	http://ftp.iptel.org/pub/ser/${PV}/src/${P}_src.tar.gz
	 mirror://gentoo/silomail-${SILOMAIL_PV}-${PN}-${MODULES_PV}.tar.gz
	 mirror://gentoo/ethz-${ETHZ_PV}-${PN}-${MODULES_PV}.tar.gz
	 ldap? (
		mirror://gentoo/ldap-${LDAP_PV}-${PN}-${MODULES_PV}.tar.gz
		mirror://gentoo/ldaps-${LDAPS_PV}-${PN}-${MODULES_PV}.tar.gz
		)"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE="ipv6 mysql radius postgres xmpp ldap ssl"

RDEPEND="
	mysql? ( virtual/mysql )
	radius? ( >=net-dialup/radiusclient-ng-0.5.0 )
	postgres? ( dev-db/postgresql:=[server] )
	xmpp? ( dev-libs/expat )
	ldap? (
		net-nds/openldap
		ssl? ( dev-libs/openssl:0= )
	)"

DEPEND="${RDEPEND}
	>=sys-devel/bison-1.35
	>=sys-devel/flex-2.5.4a"

pkg_setup() {
	enewgroup ser
	enewuser  ser -1 -1 /dev/null ser
}

src_prepare() {
	local modules extmodules MY_A MY_PATCH_A x
	use ipv6 || \
		sed -i -e "s/-DUSE_IPV6//g" Makefile.defs || die
	sed -i -e 's/\(CFLAGS+=-mcpu=ultrasparc\) -minline-all-stringops/\1/g' \
		Makefile.defs || die	#157109

	# external modules
	extmodules="silomail ethz"

	if use mysql; then
		modules="${modules} mysql"
		epatch "${FILESDIR}/${P}-mysql.diff"
	fi

	if use radius; then
		modules="${modules} auth_radius group_radius uri_radius avp_radius"
		epatch "${FILESDIR}/${P}-radius.diff"
	fi

	use xmpp && \
		modules="${modules} jabber"

	use postgres && \
		modules="${modules} postgres"

	use ldap && \
		extmodules="${extmodules} ldap"

	use ldap && use ssl && \
		extmodules="${extmodules} ldaps"

	# put list of modules into Makefile, we need the list
	# during compile and install phase...
	sed -i -e "s:^\(include_modules.*\):\1 ${modules} ${extmodules}:" \
		Makefile || die

	# fix ser.cfg
	sed -i -e "/force_send_socket(smaug:5080);/ d" \
		etc/ser.cfg || die

	# unpack external modules
	# ugly i know...
	for x in ${extmodules}; do
		MY_A=$(eval echo ${x}-\${$(echo ${x} | tr "[:lower:]" "[:upper:]")_PV}-${PN}-${MODULES_PV})
		MY_PATCH_A="${P}-extmod-${x}"
		mkdir -p "${S}"/modules/${x} || die
		cd "${S}"/modules/${x} || die
		unpack ${MY_A}.tar.gz
		# fix makefiles
		if [[ -f "${FILESDIR}"/${MY_A}.diff ]]; then
			epatch "${FILESDIR}"/${MY_A}.diff
		fi

		# additional patches
		if [[ -f "${FILESDIR}"/${MY_PATCH_A}.diff ]]; then
			epatch "${FILESDIR}"/${MY_PATCH_A}.diff
		fi
	done

	# remove sasl if openldap hasn't been built with it
	if use ldap && ! built_with_use net-nds/openldap sasl; then
		sed -i -e "s:-lsasl::g" \
			"${S}"/modules/ldap/Makefile || die

		if use ssl; then
			sed -i -e "s:-lsasl::g" \
			 "${S}"/modules/ldaps/Makefile || die
		fi
	fi
}

src_compile() {
	# add -fPIC
	append-flags -fPIC

	emake all \
		CC="`tc-getCC`" \
		CFLAGS="${CFLAGS}" \
		cfg-prefix=/ \
		cfg-target=/etc/ser/
}

src_install () {
	emake install \
		prefix="" \
		bin-prefix="${D}"/usr/sbin \
		bin-dir="" \
		cfg-prefix="${D}"/etc \
		cfg-dir=ser/ \
		cfg-target=/etc/ser/ \
		modules-prefix="${D}"/usr/$(get_libdir)/ser \
		modules-dir=modules \
		modules-target=/usr/$(get_libdir)/ser/modules/ \
		man-prefix="${D}"/usr/share/man \
		man-dir="" \
		doc-prefix="${D}"/usr/share/doc \
		doc-dir="${P}"

	newinitd "${FILESDIR}"/ser.rc6 ser
	newconfd "${FILESDIR}"/ser.confd ser
	newsbin scripts/harv_ser.sh harv_ser.sh
	newsbin scripts/sc serctl
	newsbin scripts/ser_mysql.sh ser_mysql.sh

	chown -R root:ser "${D}"/etc/ser || die
	chmod 750 "${D}"/etc/ser || die
	chmod 640 "${D}"/etc/ser/* || die

	# fix manpages
	sed -i	-e "s:^.B /ser-${PV}AUTHORS:.B /usr/share/doc/${PF}/AUTHORS:" \
		-e "s:^.B /ser:.B /usr/sbin/ser:" \
		"${D}"/usr/share/man/*/*  || die
}

pkg_preinst() {
	has_version "${CATEGORY}/${PN}"
	previous_installed_version=$?
}

pkg_postinst() {
	if [[ $previous_installed_version = 0 ]] ; then
		einfo "Changing permissions on ${ROOT}etc/ser"

		chown -R root:ser "${ROOT}"/etc/ser
		chmod 750 "${ROOT}"/etc/ser
		chmod 640 "${ROOT}"/etc/ser/*
	fi
}
