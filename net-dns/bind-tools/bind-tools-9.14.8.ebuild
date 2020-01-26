# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

MY_PN=${PN//-tools}
MY_PV=${PV/_p/-P}
MY_PV=${MY_PV/_rc/rc}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="bind tools: dig, nslookup, host, nsupdate, dnssec-keygen"
HOMEPAGE="https://www.isc.org/software/bind"
SRC_URI="https://downloads.isc.org/isc/bind9/${PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 HPND ISC MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+caps doc gssapi idn ipv6 libedit libressl readline xml"
# no PKCS11 currently as it requires OpenSSL to be patched, also see bug 409687

COMMON_DEPEND="
	caps? ( sys-libs/libcap )
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
	xml? ( dev-libs/libxml2 )
	idn? ( net-dns/libidn2:= )
	gssapi? ( virtual/krb5 )
	libedit? ( dev-libs/libedit )
	!libedit? (
		readline? ( sys-libs/readline:= )
	)"
DEPEND="${COMMON_DEPEND}"

RDEPEND="${COMMON_DEPEND}"

BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

# bug 479092, requires networking
RESTRICT="test"

src_prepare() {
	default

	export LDFLAGS="${LDFLAGS} -L${EPREFIX}/usr/$(get_libdir)"

	# Disable tests for now, bug 406399
	sed -i '/^SUBDIRS/s:tests::' bin/Makefile.in lib/Makefile.in || die

	# bug #220361
	rm aclocal.m4 || die
	rm -rf libtool.m4/ || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		--without-python
		--without-libjson
		--without-zlib
		--without-lmdb
		--with-openssl="${EPREFIX}"/usr
		$(use_with idn libidn2)
		$(use_with xml libxml2)
		$(use_with gssapi)
		$(use_with readline)
		$(use_enable caps linux-caps)
	)

	# bug 607400
	if use libedit ; then
		myeconfargs+=( --with-readline=-ledit )
	elif use readline ; then
		myeconfargs+=( --with-readline=-lreadline )
	else
		myeconfargs+=( --without-readline )
	fi

	# bug 344029
	append-cflags "-DDIG_SIGCHASE"

	# to expose CMSG_* macros from sys/sockets.h
	[[ ${CHOST} == *-solaris* ]] && append-cflags "-D_XOPEN_SOURCE=600"

	# localstatedir for nsupdate -l, bug 395785
	tc-export BUILD_CC
	econf "${myeconfargs[@]}"

	# bug #151839
	echo '#undef SO_BSDCOMPAT' >> config.h
}

src_compile() {
	local AR=$(tc-getAR)

	emake AR="${AR}" -C lib/
	emake AR="${AR}" -C bin/delv/
	emake AR="${AR}" -C bin/dig/
	emake AR="${AR}" -C bin/nsupdate/
	emake AR="${AR}" -C bin/dnssec/
}

src_install() {
	dodoc README CHANGES

	cd "${S}"/bin/delv || die
	dobin delv
	doman delv.1

	cd "${S}"/bin/dig || die
	dobin dig host nslookup
	doman {dig,host,nslookup}.1

	cd "${S}"/bin/nsupdate || die
	dobin nsupdate
	doman nsupdate.1
	if use doc; then
		docinto html
		dodoc nsupdate.html
	fi

	cd "${S}"/bin/dnssec || die
	for tool in dsfromkey importkey keyfromlabel keygen \
		revoke settime signzone verify; do
		dobin dnssec-"${tool}"
		doman dnssec-"${tool}".8
		if use doc; then
			docinto html
			dodoc dnssec-"${tool}".html
		fi
	done
}
