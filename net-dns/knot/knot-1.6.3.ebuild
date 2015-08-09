# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils user

DESCRIPTION="High-performance authoritative-only DNS server"
HOMEPAGE="http://www.knot-dns.cz/"
SRC_URI="https://secure.nic.cz/files/knot-dns/${P/_/-}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dnstap doc caps +fastparser idn lmdb systemd"

RDEPEND="
	>=dev-libs/openssl-1.0.1
	>=dev-libs/userspace-rcu-0.5.4
	caps? ( >=sys-libs/libcap-ng-0.6.4 )
	dnstap? ( dev-libs/fstrm dev-libs/protobuf-c )
	idn? ( net-dns/libidn )
	lmdb? ( dev-db/lmdb )
	systemd? ( sys-apps/systemd )
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex
	sys-devel/bison
	doc? ( dev-python/sphinx app-text/texlive-core sys-apps/texinfo )
"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	epatch "${FILESDIR}/${PV}-dont-create-extra-directories.patch"
}

src_configure() {
	econf \
		--with-storage="${EPREFIX}/var/lib/${PN}" \
		--with-rundir="${EPREFIX}/var/run/${PN}" \
		$(use_enable fastparser) \
		$(use_enable debug debug server,zones,xfr,packet,rr,ns,loader,dnssec) \
		$(use_enable debug debuglevel details) \
		$(use_enable dnstap) \
		$(use_enable lmdb) \
		$(use_with idn libidn) \
		$(usex systemd --enable-systemd=yes --enable-systemd=no)
}

src_compile() {
	default
	use doc && emake -C doc html-local singlehtml pdf-local info-local
}

# Portage's automatic test code runs "make -n check" to see if there
# is a "check" target, but that fails here because the test
# infrastructure hasn't been built yet. Just run "make check", which
# will build it and then run the tests.
src_test() {
	emake -j1 check
}

src_install() {
	default
	keepdir /var/lib/${PN}

	if use doc; then
		dodoc doc/_build/latex/KnotDNS.pdf

		docinto html
		dodoc doc/_build/html/*.html doc/_build/html/*.js
		docinto html/_sources
		dodoc doc/_build/html/_sources/*
		docinto html/_static
		dodoc doc/_build/html/_static/*

		docinto singlehtml
		dodoc doc/_build/singlehtml/index.html
		docinto singlehtml/_static/
		dodoc doc/_build/singlehtml/_static/*

		doinfo doc/_build/texinfo/KnotDNS.info
	fi

	newinitd "${FILESDIR}/knot.init" knot
}

pkg_postinst() {
	enewgroup knot 53
	enewuser knot 53 -1 /var/lib/knot knot
}
