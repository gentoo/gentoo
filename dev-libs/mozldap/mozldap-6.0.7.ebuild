# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mozldap/mozldap-6.0.7.ebuild,v 1.2 2013/03/29 03:25:30 patrick Exp $

EAPI="5"

WANT_AUTOCONF="2.1"

inherit eutils multilib versionator autotools

DESCRIPTION="Mozilla LDAP C SDK"
HOMEPAGE="http://wiki.mozilla.org/LDAP_C_SDK"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/directory/c-sdk/releases/v${PV}/src/${P}.tar.gz"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 debug +sasl"

COMMON_DEPEND=">=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.0.1
	>=dev-libs/svrcore-4.0.0
	sasl? ( dev-libs/cyrus-sasl )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${P}/c-sdk"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-6.0.4-pkgconfig.patch
	epatch "${FILESDIR}"/${P}-configure.in.patch
	epatch "${FILESDIR}"/nss-m4.patch
	epatch "${FILESDIR}"/nspr-m4.patch
	epatch "${FILESDIR}"/${PN}-6.0.6-ldflags.patch
	eautoreconf
}

src_configure() {
	local myconf="--libdir=/usr/$(get_libdir)/mozldap"
	econf $(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable amd64 64bit) \
		$(use_with sasl) \
		--with-svrcore-inc=/usr/include/svrcore \
		--with-svrcore-lib=/usr/$(get_libdir)/svrcore \
		--enable-clu \
		--enable-optimize \
		${myconf} || die "econf failed"
}

src_install () {
	# Their build system is royally fucked, as usual
	sed -e "s,%libdir%,\$\{exec_prefix\}/$(get_libdir)/${PN},g" \
	    -e "s,%prefix%,/usr,g" \
	    -e "s,%major%,$(get_major_version ${PV}),g" \
	    -e "s,%minor%,$(get_version_component_range 2 ${PV}),g" \
	    -e "s,%submin%,$(get_version_component_range 3 ${PV}),g" \
	    -e "s,%libsuffix%,$(get_major_version ${PV})$(get_version_component_range 2 ${PV}),g" \
	    -e "s,%bindir%,\$\{exec_prefix\}/$(get_libdir)/${PN},g" \
	    -e "s,%exec_prefix%,\$\{prefix\},g" \
	    -e "s,%includedir%,\$\{exec_prefix\}/include/${PN},g" \
	    -e "s,%NSPR_VERSION%,$(pkg-config --modversion nspr),g" \
	    -e "s,%NSS_VERSION%,$(pkg-config --modversion nss),g" \
	    -e "s,%SVRCORE_VERSION%,$(pkg-config --modversion svrcore),g" \
	    -e "s,%MOZLDAP_VERSION%,${PV},g" \
	   "${S}"/"${PN}".pc.in > "${S}"/"${PN}".pc || die "sed in install failed"

	emake  install || die "make failed"
	local MY_S="${WORKDIR}"/dist/

	rm -rf "${MY_S}/bin/"lib*.so
	rm -rf "${MY_S}/public/ldap-private"

	exeinto /usr/$(get_libdir)/mozldap
	doexe "${MY_S}"/lib/*so*
	doexe "${MY_S}"/lib/*.a
	doexe "${MY_S}"/bin/*

	#create compatibility PATH link

	 for i in ldapcmp ldapcompare ldapdelete ldapmodify \
		 	ldappasswd ldapsearch;do
	 	dosym /usr/$(get_libdir)/mozldap/$i /usr/bin/moz"${i}" || die
	 # compat for 389-project
		dosym /usr/$(get_libdir)/mozldap/$i /usr/bin/389-"${i}" || die
	done

	# move the headers around
	insinto /usr/include/mozldap
	doins "${MY_S}/public/ldap/"*.h

	# add sample config
	insinto /usr/share/mozldap
	doins "${MY_S}"/etc/*.conf

	#and while at it move them to files with versions-ending
	#and link them back :)
	cd "${D}"/usr/$(get_libdir)/mozldap

	#create compatibility Link
	ln -sf libldap$(get_major_version ${PV})$(get_version_component_range 2 ${PV}).so \
		liblber$(get_major_version ${PV})$(get_version_component_range 2 ${PV}).so || die
	#so lets move
	for file in *.so; do
		mv ${file} ${file}.$(get_major_version ${PV}).$(get_version_component_range 2 ${PV}) || die
		ln -sf ${file}.$(get_major_version ${PV}).$(get_version_component_range 2 ${PV}) ${file} || die
		ln -sf ${file}.$(get_major_version ${PV}).$(get_version_component_range 2 ${PV}) \
			${file}.$(get_major_version ${PV}) || die
	done

	# cope with libraries being in /usr/lib/mozldap
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/mozldap" > "${D}"/etc/env.d/08mozldap

	# create pkg-config file
	insinto /usr/$(get_libdir)/pkgconfig/
	doins "${S}"/mozldap.pc
}
