# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils autotools flag-o-matic toolchain-funcs

MY_PN=${PN//-tools}
MY_PV=${PV/_p/-P}
MY_PV=${MY_PV/_rc/rc}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="bind tools: dig, nslookup, host, nsupdate, dnssec-keygen"
HOMEPAGE="http://www.isc.org/software/bind"
SRC_URI="ftp://ftp.isc.org/isc/bind9/${MY_PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 HPND ISC MPL-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc gost gssapi idn ipv6 libressl readline seccomp ssl urandom xml"
# no PKCS11 currently as it requires OpenSSL to be patched, also see bug 409687

REQUIRED_USE="gost? ( !libressl ssl )"

CDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	gost? ( >=dev-libs/openssl-1.0.0:0[-bindist] )
	xml? ( dev-libs/libxml2 )
	idn? ( net-dns/idnkit )
	gssapi? ( virtual/krb5 )
	readline? ( sys-libs/readline:0= )
	seccomp? ( sys-libs/libseccomp )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	!<net-dns/bind-9.10.2"

S="${WORKDIR}/${MY_P}"

# bug 479092, requires networking
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-9.5.0_p1-lwconfig.patch #231247

	# Disable tests for now, bug 406399
	sed -i '/^SUBDIRS/s:tests::' bin/Makefile.in lib/Makefile.in || die

	# bug #220361
	rm aclocal.m4
	rm -rf libtool.m4/

	mv configure.in configure.ac || die # configure.in is deprecated
	eautoreconf
}

src_configure() {
	local myconf=

	if use urandom; then
		myconf="${myconf} --with-randomdev=/dev/urandom"
	else
		myconf="${myconf} --with-randomdev=/dev/random"
	fi

	# bug 344029
	append-cflags "-DDIG_SIGCHASE"

	# localstatedir for nsupdate -l, bug 395785
	tc-export BUILD_CC
	econf \
		--localstatedir=/var \
		--without-python \
		--without-libjson \
		--without-zlib \
		--without-lmdb \
		--disable-openssl-version-check \
		$(use_enable ipv6) \
		$(use_with idn) \
		$(usex idn --with-idnlib=-lidnkit '') \
		$(use_enable seccomp) \
		$(use_with ssl openssl) \
		$(use_with xml libxml2) \
		$(use_with gssapi) \
		$(use_with readline) \
		$(use_with gost) \
		${myconf}

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
	dodoc README CHANGES FAQ

	cd "${S}"/bin/delv
	dobin delv
	doman delv.1

	cd "${S}"/bin/dig
	dobin dig host nslookup
	doman {dig,host,nslookup}.1

	cd "${S}"/bin/nsupdate
	dobin nsupdate
	doman nsupdate.1
	if use doc; then
		dohtml nsupdate.html
	fi

	cd "${S}"/bin/dnssec
	for tool in dsfromkey importkey keyfromlabel keygen \
	  revoke settime signzone verify; do
		dobin dnssec-"${tool}"
		doman dnssec-"${tool}".8
		if use doc; then
			dohtml dnssec-"${tool}".html
		fi
	done
}
