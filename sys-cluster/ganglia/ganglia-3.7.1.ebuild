# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/ganglia/ganglia-3.7.1.ebuild,v 1.1 2015/08/05 13:04:54 jsbronder Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-single-r1 systemd

DESCRIPTION="A scalable distributed monitoring system for clusters and grids"
HOMEPAGE="http://ganglia.sourceforge.net/"
SRC_URI="mirror://sourceforge/ganglia/${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="minimal pcre python examples"

DEPEND="dev-libs/confuse
	dev-libs/expat
	>=dev-libs/apr-1.0
	!dev-db/firebird
	pcre? ( dev-libs/libpcre )
	python? ( ${PYTHON_DEPS} )"

RDEPEND="
	${DEPEND}
	!minimal? ( net-analyzer/rrdtool )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	econf \
		--with-systemdsystemunitdir=$(systemd_get_unitdir) \
		--enable-gexec \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--enable-static=no \
		$(use_enable python) \
		$(use_with pcre libpcre) \
		$(use_with !minimal gmetad)
}

src_install() {
	local exdir=/usr/share/doc/${P}

	emake DESTDIR="${D}" install || die

	newinitd "${FILESDIR}"/gmond.rc-2 gmond
	doman {mans/*.1,gmond/*.5} || die "Failed to install manpages"
	dodoc AUTHORS INSTALL NEWS README || die

	dodir /etc/ganglia/conf.d
	use python && dodir /usr/$(get_libdir)/ganglia/python_modules
	gmond/gmond -t > "${ED}"/etc/ganglia/gmond.conf

	if use examples; then
		insinto ${exdir}/cmod-examples
		doins gmond/modules/example/*.c
		if use python; then
			# Installing as an examples per upstream.
			insinto ${exdir}/pymod-examples
			doins gmond/python_modules/*/*.py
			insinto ${exdir}/pymod-examples/conf.d
			doins gmond/python_modules/conf.d/*.pyconf
		fi
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
