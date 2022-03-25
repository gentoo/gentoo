# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fixheadtails multilib-minimal prefix

DESCRIPTION="NSS LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/nss_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ppc64 sparc x86 ~amd64-linux"
IUSE="debug kerberos ssl sasl split-usr"

DEPEND="
	>=net-nds/openldap-2.4.38-r1:=[${MULTILIB_USEDEP}]
	sasl? ( >=dev-libs/cyrus-sasl-2.1.26-r3[${MULTILIB_USEDEP}] )
	kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	ssl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
	!<net-fs/autofs-4.1.3
"

src_prepare() {
	default

	# Patch is for Prefix
	# eprefixify is safe on non-Prefix systems, so go unconditional
	# Note: comment this out or make it conditional on 'use prefix'
	# if needs rebasing. Don't remove.
	eapply "${FILESDIR}"/${P}-r10-libdir.patch
	eprefixify Makefile.am

	# bug 438692
	eapply -p0 "${FILESDIR}"/${P}-pthread.patch

	eapply -p0 "${FILESDIR}"/nsswitch.ldap.diff

	# Applied by upstream
	#eapply "${FILESDIR}"/${PN}-239-tls-security-bug.patch

	eapply -p0 "${FILESDIR}"/${PN}-249-sasl-compile.patch

	eapply "${FILESDIR}"/${PN}-265-reconnect-timeouts.patch

	# Applied by upstream
	#eapply "${FILESDIR}"/${PN}-254-nss_getgrent_skipmembers.patch

	eapply "${FILESDIR}"/${PN}-257-nss_max_group_depth.patch

	sed -i.orig \
		-e '/^ @(#)\$Id: ldap.conf,v/s,^,#,' \
		"${S}"/ldap.conf \
		|| die

	# Fix head/tail stuff
	ht_fix_file "${S}"/Makefile.am "${S}"/Makefile.in "${S}"/depcomp

	# Fix build borkage
	local i
	for i in Makefile.{in,am}; do
		sed -i.orig \
			-e '/^install-exec-local: nss_ldap.so/s,nss_ldap.so,,g' \
			"${S}"/$i || die
	done

	eapply "${FILESDIR}"/${PN}-257.2-gssapi-headers.patch

	# Bug #214750, no automagic deps
	eapply "${FILESDIR}"/${PN}-264-disable-automagic.patch

	# Upstream forgets the version number sometimes
	#sed -i \
	#	-e "/^AM_INIT_AUTOMAKE/s~2..~$PV~" \
	#	"${S}"/configure.in || die

	# Include an SONAME
	eapply "${FILESDIR}"/${PN}-254-soname.patch

	# Fix broken oneshot connections
	eapply "${FILESDIR}/nss_ldap-265-missing-entries-oneshot.patch"

	sed -i \
		-e 's, vers_string , PERL5LIB="@top_srcdir@" @top_srcdir@/vers_string ,g' \
		"${S}"/Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		# --enable-schema-mapping
		--with-ldap-lib=openldap
		--with-ldap-conf-file="${EPREFIX}/etc/ldap.conf"
		--enable-paged-results
		--enable-rfc2307bis
		$(use_enable ssl)
		$(use_enable sasl)
		$(use_enable kerberos krb)
	)

	use debug && myconf+=( --enable-debugging )
	use kerberos && myconf+=( --enable-configurable-krb5-ccname-gssapi )

	# Neede to be careful with changing this
	# bug #581306
	multilib_is_native_abi && myconf+=( --libdir="${EPREFIX}/$(get_libdir)" )

	ECONF_SOURCE=${S} econf "${myconf[@]}"
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" \
		LIBDIR_UNPREFIXED="$(get_libdir)" \
		INST_UID=${PORTAGE_USER:-root} \
		INST_GID=${PORTAGE_GROUP:-root} \
		install
}

multilib_src_install_all() {
	use split-usr &&
		dosym ../../$(get_libdir)/libnss_ldap.so.2 /usr/$(get_libdir)/libnss_ldap.so.2

	insinto /etc
	doins ldap.conf

	# Append two blank lines and some skip entries
	echo >>"${ED}"/etc/ldap.conf || die
	echo >>"${ED}"/etc/ldap.conf || die
	sed -i "${ED}"/etc/ldap.conf \
		-e '$inss_initgroups_ignoreusers ldap,openldap,mysql,syslog,root,postgres' \
		|| die

	dodoc ldap.conf ANNOUNCE NEWS ChangeLog AUTHORS \
		CVSVersionInfo.txt README nsswitch.ldap certutil

	docinto docs
	dodoc -r doc/.
}

pkg_postinst() {
	elog "If you use a ldaps:// string in the 'uri' setting of"
	elog "your /etc/ldap.conf, you must set 'ssl on'!"
}
