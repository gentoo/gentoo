# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user systemd bash-completion-r1 autotools

DESCRIPTION="Implementation of IEEE 802.1ab (LLDP)"
HOMEPAGE="https://vincentbernat.github.com/lldpd/"
SRC_URI="http://media.luffy.cx/files/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdp doc +dot1 +dot3 edp fdp graph +lldpmed old-kernel sanitizers
	seccomp sonmp snmp static-libs test readline xml zsh-completion"

RDEPEND="dev-libs/libbsd
	>=dev-libs/libevent-2.0.5:=
	sys-libs/readline:0=
	snmp? ( net-analyzer/net-snmp[extensible(+)] )
	xml? ( dev-libs/libxml2 )
	seccomp? ( sys-libs/libseccomp )
	zsh-completion? ( app-shells/zsh )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		graph? ( app-doc/doxygen[dot] )
		!graph? ( app-doc/doxygen )
	)
	test? ( dev-libs/check )"

REQUIRED_USE="graph? ( doc )"

PATCHES=(
	"${FILESDIR}/lldpd-0.9.5-seccomp-add-socket-ops.patch"
	"${FILESDIR}/lldpd-1.0.1-seccomp-add-brk.patch"
	"${FILESDIR}/lldpd-1.0.2-seccomp-add-misc.patch"
	"${FILESDIR}/lldpd-1.0.3-fix-fdp-without-cdp.patch"
)

pkg_setup() {
	ebegin "Creating lldpd user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend $?
}

src_prepare() {
	default

	eautoreconf
	elibtoolize
}

src_configure() {
	econf \
		--without-embedded-libevent \
		--with-privsep-user=${PN} \
		--with-privsep-group=${PN} \
		--with-privsep-chroot=/run/${PN} \
		--with-lldpd-ctl-socket=/run/${PN}.socket \
		--with-lldpd-pid-file=/run/${PN}.pid \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable cdp) \
		$(use_enable doc doxygen-man) \
		$(use_enable doc doxygen-pdf) \
		$(use_enable doc doxygen-html) \
		$(use_enable dot1) \
		$(use_enable dot3) \
		$(use_enable edp) \
		$(use_enable fdp) \
		$(use_enable graph doxygen-dot) \
		$(use_enable lldpmed) \
		$(use_enable old-kernel oldies) \
		$(use_enable sonmp) \
		$(use_enable static-libs static) \
		$(use_with readline) \
		$(use_enable sanitizers) \
		$(use_with seccomp) \
		$(use_with snmp) \
		$(use_with xml)
}

src_compile() {
	emake
	use doc && emake doxygen-doc
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files

	newinitd "${FILESDIR}"/${PN}-initd-5 ${PN}
	newconfd "${FILESDIR}"/${PN}-confd-1 ${PN}
	newbashcomp src/client/completion/lldpcli lldpcli

	use doc && dodoc -r doxygen/html

	insinto /etc
	doins "${FILESDIR}/lldpd.conf"
	keepdir /etc/${PN}.d

	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/tmpfilesd ${PN}.conf
}
