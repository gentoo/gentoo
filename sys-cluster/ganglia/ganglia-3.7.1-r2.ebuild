# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic systemd toolchain-funcs

DESCRIPTION="A scalable distributed monitoring system for clusters and grids"
HOMEPAGE="http://ganglia.sourceforge.net/"
SRC_URI="mirror://sourceforge/ganglia/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"
IUSE="minimal pcre examples"

DEPEND="dev-libs/confuse
	dev-libs/expat
	>=dev-libs/apr-1.0
	net-libs/libnsl:0=
	net-libs/libtirpc:0=
	!dev-db/firebird
	pcre? ( dev-libs/libpcre )"

RDEPEND="
	${DEPEND}
	!minimal? ( net-analyzer/rrdtool )"

BDEPEND="virtual/pkgconfig"

src_configure() {
	append-flags $("$(tc-getPKG_CONFIG)" --cflags libtirpc)
	append-libs $("$(tc-getPKG_CONFIG)" --libs libtirpc)

	econf \
		--with-systemdsystemunitdir=$(systemd_get_systemunitdir) \
		--enable-gexec \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--enable-static=no \
		--disable-python \
		$(use_with pcre libpcre) \
		$(use_with !minimal gmetad)
}

src_install() {
	local exdir=/usr/share/doc/${P}

	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/gmond.rc-2 gmond
	doman {mans/*.1,gmond/*.5}
	dodoc AUTHORS INSTALL NEWS README

	dodir /etc/ganglia/conf.d
	gmond/gmond -t > "${ED}"/etc/ganglia/gmond.conf

	if use examples; then
		insinto ${exdir}/cmod-examples
		doins gmond/modules/example/*.c
	fi

	if ! use minimal; then
		insinto /etc/ganglia
		doins gmetad/gmetad.conf
		doman mans/gmetad.1

		newinitd "${FILESDIR}"/gmetad.rc-2 gmetad
		keepdir /var/lib/ganglia/rrds
		fowners nobody:nobody /var/lib/ganglia/rrds
	fi
}

pkg_postinst() {
	elog "A default configuration file for gmond has been generated"
	elog "for you as a template by running:"
	elog "    /usr/sbin/gmond -t > /etc/ganglia/gmond.conf"

	elog "The web frontend for Ganglia has been split off.  Emerge"
	elog "sys-cluster/ganglia-web if you need it."
}
