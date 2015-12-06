# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils multilib pax-utils user

DESCRIPTION="Apache CouchDB is a distributed, fault-tolerant and schema-free document-oriented database."
HOMEPAGE="http://couchdb.apache.org/"
SRC_URI="mirror://apache/couchdb/source/${PV}/apache-${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="libressl selinux test"

RDEPEND=">=dev-libs/icu-4.3.1:=
		dev-lang/erlang[ssl]
		!libressl? ( >=dev-libs/openssl-0.9.8j:0 )
		libressl? ( dev-libs/libressl )
		>=net-misc/curl-7.18.2
		<dev-lang/spidermonkey-1.8.7
		selinux? ( sec-policy/selinux-couchdb )"

DEPEND="${RDEPEND}
		sys-devel/autoconf-archive"
RESTRICT=test

S="${WORKDIR}/apache-${P}"

pkg_setup() {
	enewgroup couchdb
	enewuser couchdb -1 -1 /var/lib/couchdb couchdb
}

src_prepare() {
	sed -i ./src/couchdb/priv/Makefile.* -e 's|-Werror||g'
	epatch "${FILESDIR}/${PV}-erlang-18.patch"
	eautoreconf
}

src_configure() {
	econf \
		--with-erlang="${EPREFIX}"/usr/$(get_libdir)/erlang/usr/include \
		--localstatedir="${EPREFIX}"/var \
		--with-js-lib="${EPREFIX}"/usr/$(get_libdir)
	# bug 296609, upstream bug #COUCHDB-621
	sed -e "s#localdocdir = /usr/share/doc/couchdb#localdocdir = "${EPREFIX}"/usr/share/doc/${PF}#" -i Makefile || die "sed failed"
}

src_compile() {
	emake
	# bug 442616
	pax-mark mr src/couchdb/priv/couchjs
}

src_test() {
	emake distcheck
}

src_install() {
	emake DESTDIR="${D}" install

	fowners couchdb:couchdb \
		/var/lib/couchdb \
		/var/log/couchdb

	for f in "${ED}"/etc/couchdb/*.ini ; do
		fowners root:couchdb "${f#${ED}}"
		fperms 660 "${f#${ED}}"
	done
	fperms 664 /etc/couchdb/default.ini

	newinitd "${FILESDIR}/couchdb.init-4" couchdb
	newconfd "${FILESDIR}/couchdb.conf-2" couchdb

	sed -i -e "s:LIBDIR:$(get_libdir):" "${ED}/etc/conf.d/couchdb"
}
