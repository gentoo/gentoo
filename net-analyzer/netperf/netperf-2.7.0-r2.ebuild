# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic user

DESCRIPTION="Network performance benchmark"
SRC_URI="ftp://ftp.netperf.org/${PN}/${P}.tar.bz2"
KEYWORDS="~alpha amd64 arm64 ~hppa ~ia64 ppc ppc64 sparc x86"

HOMEPAGE="http://www.netperf.org/"
LICENSE="netperf"
SLOT="0"
IUSE="demo sctp"

PATCHES=(
	"${FILESDIR}"/${PN}-fix-scripts.patch
	"${FILESDIR}"/${PN}-2.6.0-log-dir.patch
	"${FILESDIR}"/${PN}-2.7.0-includes.patch
	"${FILESDIR}"/${PN}-2.7.0-space.patch
	"${FILESDIR}"/${PN}-2.7.0-inline.patch
)

pkg_setup() {
	enewuser netperf
	enewgroup netperf
}

src_prepare() {
	# Fixing paths in scripts
	sed -i \
		-e 's:^\(NETHOME=\).*:\1"/usr/bin":' \
		doc/examples/sctp_stream_script \
		doc/examples/tcp_range_script \
		doc/examples/tcp_rr_script \
		doc/examples/tcp_stream_script \
		doc/examples/udp_rr_script \
		doc/examples/udp_stream_script \
		|| die

	default
}

src_configure() {
	append-cflags -fcommon

	# netlib.c:2292:5: warning: implicit declaration of function ‘sched_setaffinity’
	# nettest_omni.c:2943:5: warning: implicit declaration of function ‘splice’
	append-cppflags -D_GNU_SOURCE

	econf \
		$(use_enable demo) \
		$(use_enable sctp)
}

src_install() {
	default

	# Move netserver into sbin as we had it before 2.4 was released with its
	# autoconf goodness
	dodir /usr/sbin
	mv "${ED}"/usr/{bin,sbin}/netserver || die

	# init.d / conf.d
	newinitd "${FILESDIR}"/${PN}-2.7.0-init netperf
	newconfd "${FILESDIR}"/${PN}-2.2-conf netperf

	keepdir /var/log/${PN}
	fowners netperf:netperf /var/log/${PN}
	fperms 0755 /var/log/${PN}

	# documentation and example scripts
	dodoc AUTHORS ChangeLog NEWS README Release_Notes
	dodir /usr/share/doc/${PF}/examples
	# Scripts no longer get installed by einstall
	cp doc/examples/*_script "${ED}"/usr/share/doc/${PF}/examples || die
}
