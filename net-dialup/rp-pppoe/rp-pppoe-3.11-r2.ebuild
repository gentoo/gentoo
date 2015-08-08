# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic autotools

PPP_P="ppp-2.4.7"

DESCRIPTION="A user-mode PPPoE client and server suite for Linux"
HOMEPAGE="http://www.roaringpenguin.com/pppoe/"
SRC_URI="http://www.roaringpenguin.com/files/download/${P}.tar.gz
	ftp://ftp.samba.org/pub/ppp/${PPP_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="X"

RDEPEND="net-dialup/ppp
	X? ( dev-lang/tk )"
# see bug #230491
DEPEND="|| ( <sys-kernel/linux-headers-2.6.24 >=sys-kernel/linux-headers-2.6.25 )
	${RDEPEND}"

src_prepare() {
	# Patch to enable integration of pppoe-start and pppoe-stop with
	# baselayout-1.11.x so that the pidfile can be found reliably per interface
	epatch "${FILESDIR}/${PN}-3.10-gentoo-netscripts.patch"

	epatch "${FILESDIR}/${PN}-3.10-username-charset.patch" # bug 82410
	epatch "${FILESDIR}/${PN}-3.10-plugin-options.patch"
	epatch "${FILESDIR}/${PN}-3.10-autotools.patch"
	epatch "${FILESDIR}/${PN}-3.10-session-offset.patch" # bug 204476
	has_version '<sys-kernel/linux-headers-2.6.35' && \
		epatch "${FILESDIR}/${PN}-3.10-linux-headers.patch" #334197
	epatch "${FILESDIR}/${PN}-3.10-posix-source-sigaction.patch"
	epatch "${FILESDIR}/${PN}-3.11-gentoo.patch"

	cd "${S}"/src || die
	eautoreconf
}

src_configure() {
	addpredict /dev/ppp

	cd "${S}/src" || die
	econf --enable-plugin=../../${PPP_P}
}

src_compile() {
	cd "${S}/src" || die
	emake

	if use X; then
		make -C "${S}/gui" || die "gui make failed"
	fi
}

src_install () {
	cd "${S}/src" || die
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF} install

	#Don't use compiled rp-pppoe plugin - see pkg_preinst below
	local pppoe_plugin="${D}/etc/ppp/plugins/rp-pppoe.so"
	if [ -f "${pppoe_plugin}" ] ; then
		rm "${pppoe_plugin}" || die
	fi

	if use X; then
		emake -C "${S}/gui" \
			DESTDIR="${D}" \
			datadir=/usr/share/doc/${PF}/ \
			install
		dosym /usr/share/doc/${PF}/tkpppoe /usr/share/tkpppoe
	fi
}

pkg_preinst() {
	# Use the rp-pppoe plugin that comes with net-dialup/pppd
	local PPPD_VER=$(best_version net-dialup/ppp)
	PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%-*} #reduce it to ${PV}
	if [ -n "${PPPD_VER}" ] && [ -f "${ROOT}/usr/lib/pppd/${PPPD_VER}/rp-pppoe.so" ] ; then
		dosym /usr/lib/pppd/${PPPD_VER}/rp-pppoe.so /etc/ppp/plugins/rp-pppoe.so
	fi
}

pkg_postinst() {
	elog "Use pppoe-setup to configure your dialup connection."
}
