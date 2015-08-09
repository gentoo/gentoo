# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils user systemd bash-completion-r1 autotools

DESCRIPTION="Implementation of IEEE 802.1ab (LLDP)"
HOMEPAGE="http://vincentbernat.github.com/lldpd/"
SRC_URI="http://media.luffy.cx/files/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cdp doc +dot1 +dot3 edp fdp graph jansson json-c +lldpmed seccomp sonmp
	snmp static-libs readline xml zsh-completion"

RDEPEND=">=dev-libs/libevent-2.0.5
		snmp? ( net-analyzer/net-snmp[extensible(+)] )
		xml? ( dev-libs/libxml2 )
		jansson? ( dev-libs/jansson )
		json-c? ( dev-libs/json-c )
		seccomp? ( sys-libs/libseccomp )
		zsh-completion? ( app-shells/zsh )"
DEPEND="${RDEPEND}
		virtual/pkgconfig
		doc? (
			graph? ( app-doc/doxygen[dot] )
			!graph? ( app-doc/doxygen )
		)"

REQUIRED_USE="graph? ( doc ) json-c? ( !jansson )"

PATCHES=(
	"${FILESDIR}"/${P}-zsh-completion-dir.patch
	"${FILESDIR}"/${P}-bash-completion-dir.patch
)

pkg_setup() {
	ebegin "Creating lldpd user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend $?
}

src_prepare() {
	epatch "${PATCHES[@]}"
	epatch_user
	eautoreconf
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
		$(use_enable graph doxygen-dot) \
		$(use_enable doc doxygen-man) \
		$(use_enable doc doxygen-pdf) \
		$(use_enable doc doxygen-html) \
		$(use_enable cdp) \
		$(use_enable dot1) \
		$(use_enable dot3) \
		$(use_enable edp) \
		$(use_enable fdp) \
		$(use_enable lldpmed) \
		$(use_enable sonmp) \
		$(use_enable static-libs static) \
		$(use_with json-c) \
		$(use_with jansson) \
		$(use_with readline) \
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

	newinitd "${FILESDIR}"/${PN}-initd-4 ${PN}
	newconfd "${FILESDIR}"/${PN}-confd-1 ${PN}
	newbashcomp src/client/lldpcli.bash-completion lldpcli

	use doc && dohtml -r doxygen/html/*

	keepdir /etc/${PN}.d

	systemd_dounit "${FILESDIR}"/${PN}.service
}
