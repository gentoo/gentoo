# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/isc.asc
inherit autotools flag-o-matic multiprocessing toolchain-funcs verify-sig

MY_PN=${PN//-tools}
MY_PV=${PV/_p/-P}
MY_PV=${MY_PV/_rc/rc}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="bind tools: dig, nslookup, host, nsupdate, dnssec-keygen"
HOMEPAGE="https://www.isc.org/software/bind https://gitlab.isc.org/isc-projects/bind9"
SRC_URI="
	https://downloads.isc.org/isc/bind9/${PV}/${MY_P}.tar.xz
	verify-sig? ( https://downloads.isc.org/isc/bind9/${PV}/${MY_P}.tar.xz.asc )
"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 HPND ISC MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+caps doc gssapi idn libedit readline test xml"
# no PKCS11 currently as it requires OpenSSL to be patched, also see bug #409687
RESTRICT="!test? ( test )"

# libuv lower bound should be the highest value seen at
# https://gitlab.isc.org/isc-projects/bind9/-/blob/bind-9.16/lib/isc/netmgr/netmgr.c?ref_type=heads#L244
# to avoid issues with matching stable/testing, etc
RDEPEND="
	>=dev-libs/libuv-1.42.0:=
	dev-libs/openssl:=
	caps? ( sys-libs/libcap )
	xml? ( dev-libs/libxml2 )
	idn? ( net-dns/libidn2:= )
	gssapi? ( virtual/krb5 )
	libedit? ( dev-libs/libedit )
	!libedit? (
		readline? ( sys-libs/readline:= )
	)
"
DEPEND="${RDEPEND}"
# sphinx required for man-page and html creation
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
	test? (
		dev-util/cmocka
		dev-util/kyua
	)
	verify-sig? ( sec-keys/openpgp-keys-isc )
"

src_prepare() {
	default

	# Do not disable thread local storage on Solaris, it works with our
	# toolchain, and it breaks further configure checks
	sed -i -e '/LDFLAGS=/s/-zrelax=transtls//' configure.ac configure || die

	# Slow tests
	sed -i "s/{name='mem_test'}/{name='mem_test',timeout=900}/" "lib/isc/tests/Kyuafile" || die
	sed -i "s/{name='timer_test'}/{name='timer_test',timeout=900}/" "lib/isc/tests/Kyuafile" || die

	# Conditionally broken
	use sparc && ( sed -i "/{name='netmgr_test'}/d" "lib/isc/tests/Kyuafile" || die )

	# bug #220361
	rm aclocal.m4 || die
	rm -rf libtool.m4/ || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		# localstatedir for nsupdate -l, bug #395785
		--localstatedir="${EPREFIX}"/var
		--without-python
		--without-libjson
		--without-zlib
		--without-lmdb
		--without-maxminddb
		--disable-geoip
		--with-openssl="${ESYSROOT}"/usr
		$(use_with idn libidn2 "${ESYSROOT}"/usr)
		$(use_with xml libxml2)
		$(use_with gssapi)
		$(use_with readline)
		$(use_enable caps linux-caps)
		AR="$(type -P $(tc-getAR))"
	)

	# bug #607400
	if use libedit ; then
		myeconfargs+=( --with-readline=-ledit )
	elif use readline ; then
		myeconfargs+=( --with-readline=-lreadline )
	else
		myeconfargs+=( --without-readline )
	fi

	# bug #344029
	append-cflags "-DDIG_SIGCHASE"

	append-ldflags "-L${ESYSROOT}/usr/$(get_libdir)"

	# to expose CMSG_* macros from sys/sockets.h
	[[ ${CHOST} == *-solaris* ]] && append-cflags "-D_XOPEN_SOURCE=600"

	tc-export BUILD_CC
	econf "${myeconfargs[@]}"

	# bug #151839
	echo '#undef SO_BSDCOMPAT' >> config.h || die
}

src_compile() {
	local AR="$(tc-getAR)"

	emake AR="${AR}" -C lib/
	emake AR="${AR}" -C bin/delv/
	emake AR="${AR}" -C bin/dig/
	emake AR="${AR}" -C bin/nsupdate/
	emake AR="${AR}" -C bin/dnssec/
	emake -C doc/man/ man $(usev doc)
}

src_test() {
	# system tests ('emake test') require network configuration for IPs etc
	# so we run the unit tests instead.
	TEST_PARALLEL_JOBS="$(makeopts_jobs)" emake -Onone unit
}

src_install() {
	local man_dir="${S}/doc/man"
	local html_dir="${man_dir}/_build/html"

	dodoc README CHANGES

	cd "${S}"/bin/delv || die
	dobin delv
	doman ${man_dir}/delv.1

	cd "${S}"/bin/dig || die
	dobin dig host nslookup
	doman ${man_dir}/{dig,host,nslookup}.1

	cd "${S}"/bin/nsupdate || die
	dobin nsupdate
	doman ${man_dir}/nsupdate.1
	if use doc; then
		docinto html
		dodoc ${html_dir}/nsupdate.html
	fi

	cd "${S}"/bin/dnssec || die
	local tool
	for tool in dsfromkey importkey keyfromlabel keygen \
		revoke settime signzone verify; do
		dobin dnssec-"${tool}"
		doman ${man_dir}/dnssec-"${tool}".8
		if use doc; then
			docinto html
			dodoc ${html_dir}/dnssec-"${tool}".html
		fi
	done
}
