# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

COMMIT="3bc455b23f901dae377ca0a558e1e32aa56b31c4"
DESCRIPTION="Network performance benchmark"
HOMEPAGE="https://github.com/HewlettPackard/netperf"
SRC_URI="https://github.com/HewlettPackard/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="demo sctp"

RDEPEND="
	acct-group/netperf
	acct-user/netperf
"
BDEPEND="
	${RDEPEND}
	sys-devel/gnuconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-fix-scripts.patch
	"${FILESDIR}"/${PN}-log-dir.patch
	"${FILESDIR}"/${PN}-2.7.0-includes.patch
	"${FILESDIR}"/${PN}-2.7.0-fcommon.patch
)

src_prepare() {
	# Fixing paths in scripts
	sed -i \
		-e "s:^\(NETHOME=\).*:\1\"${EPREFIX}/usr/bin\":" \
		doc/examples/sctp_stream_script \
		doc/examples/tcp_range_script \
		doc/examples/tcp_rr_script \
		doc/examples/tcp_stream_script \
		doc/examples/udp_rr_script \
		doc/examples/udp_stream_script \
		|| die

	default
	AT_M4DIR=src/missing/m4 eautoreconf
}

src_configure() {
	# netlib.c:2292:5: warning: implicit declaration of function ‘sched_setaffinity’
	# nettest_omni.c:2943:5: warning: implicit declaration of function ‘splice’
	# TODO: drop once https://github.com/HewlettPackard/netperf/pull/73 merged
	append-cppflags -D_GNU_SOURCE

	econf \
		$(use_enable demo) \
		$(use_enable sctp)
}

src_install() {
	default

	# init.d / conf.d
	newinitd "${FILESDIR}"/${PN}-2.7.0-init netperf
	newconfd "${FILESDIR}"/${PN}-2.2-conf netperf

	keepdir /var/log/${PN}
	fowners netperf:netperf /var/log/${PN}
	fperms 0755 /var/log/${PN}

	# documentation and example scripts
	dodoc AUTHORS ChangeLog NEWS README Release_Notes doc/${PN}.txt
	docinto html
	dodoc doc/${PN}.html
	exeinto /usr/share/${PN}/examples
	doexe doc/examples/*_script
}
