# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit flag-o-matic

MY_PN=${PN//-tools}
MY_PV=${PV/_p/-P}
MY_PV=${MY_PV/_rc/rc}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="bind tools: dig, nslookup, host, dnssec and friends"
HOMEPAGE="https://www.isc.org/software/bind"
SRC_URI="https://downloads.isc.org/isc/bind9/${PV}/${MY_P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+caps gssapi idn libedit lmdb readline static-libs xml"

COMMON_DEPEND="
	dev-libs/libuv:=
	dev-libs/jemalloc
	dev-libs/openssl:=
	caps? ( sys-libs/libcap )
	gssapi? ( virtual/krb5 )
	idn? ( net-dns/libidn2:= )
	libedit? ( dev-libs/libedit )
	!libedit? (
		readline? ( sys-libs/readline:= )
	)
	lmdb? ( dev-db/lmdb )
	xml? ( dev-libs/libxml2 )
"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	!net-dns/bind"

S="${WORKDIR}/${MY_P}"

# bug 479092, requires networking
RESTRICT="test"

src_configure() {
	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		--with-jemalloc
		--with-json-c
		--with-zlib
		--without-maxminddb
		--disable-geoip
		--with-openssl="${ESYSROOT}"/usr
		$(use_enable caps linux-caps)
		$(use_enable static-libs static)
		$(use_with gssapi)
		$(use_with idn libidn2 "${ESYSROOT}"/usr)
		$(use_with lmdb)
		$(use_with xml libxml2)
	)

	# bug 607400
	if use libedit ; then
		myeconfargs+=( --with-readline=libedit )
	elif use readline ; then
		myeconfargs+=( --with-readline )
	else
		myeconfargs+=( --without-readline )
	fi

	# to expose CMSG_* macros from sys/sockets.h
	[[ ${CHOST} == *-solaris* ]] && append-cflags "-D_XOPEN_SOURCE=600"

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake bind.keys.h
	emake -C lib/
	emake -C bin/delv/
	emake -C bin/dig/
	emake -C bin/nsupdate/
	emake -C bin/dnssec/
	emake -C bin/tools/
	emake -C doc/man/ man
}

src_install() {
	local man_dir="${S}/doc/man"

	dodoc README.md CHANGES

	emake DESTDIR="${D}" -C lib/ install

	emake DESTDIR="${D}" -C bin/delv/ install
	doman ${man_dir}/delv.1

	emake DESTDIR="${D}" -C bin/dig/ install
	doman ${man_dir}/{dig,host,nslookup}.1

	emake DESTDIR="${D}" -C bin/nsupdate/ install
	doman ${man_dir}/nsupdate.1

	emake DESTDIR="${D}" -C bin/dnssec/ install
	for tool in cds dsfromkey importkey keyfromlabel keygen \
		revoke settime signzone verify; do
		doman ${man_dir}/dnssec-"${tool}".1
	done

	emake DESTDIR="${D}" -C bin/tools/ install
	doman ${man_dir}/{arpaname,mdig,named-journalprint,named-rrchecker,nsec3hash}.1

	# just leave the tools to be installed
	rm -rf "${D}"/usr/include/

	use static-libs || find "${ED}"/usr/lib* -name '*.la' -delete
}
