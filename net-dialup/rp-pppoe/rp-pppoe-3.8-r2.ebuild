# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/rp-pppoe/rp-pppoe-3.8-r2.ebuild,v 1.13 2013/05/12 04:00:43 patrick Exp $

inherit eutils flag-o-matic autotools

DESCRIPTION="A user-mode PPPoE client and server suite for Linux"
HOMEPAGE="http://www.roaringpenguin.com/pppoe/"
SRC_URI="http://www.roaringpenguin.com/penguin/pppoe/${P}.tar.gz
	ftp://ftp.samba.org/pub/ppp/ppp-2.4.3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~mips ppc ppc64 sh sparc x86"
IUSE="X"

RDEPEND="net-dialup/ppp
	X? ( dev-lang/tk )"
# see bug #230491
DEPEND="|| ( <sys-kernel/linux-headers-2.6.24 >=sys-kernel/linux-headers-2.6.25 )
	${RDEPEND}"

src_unpack() {
	unpack ${A} || die "failed to unpack"

	# Patch to enable integration of pppoe-start and pppoe-stop with
	# baselayout-1.11.x so that the pidfile can be found reliably per interface
	epatch "${FILESDIR}/${P}-gentoo-netscripts.patch"

	epatch "${FILESDIR}/${P}-username-charset.patch" # bug 82410
	epatch "${FILESDIR}/${P}-plugin-options.patch"
	epatch "${FILESDIR}/${P}-configure.patch"
	epatch "${FILESDIR}/${P}-autoheader.patch"
	epatch "${FILESDIR}/${P}-session-offset.patch" # bug 204476

	cd "${S}"/src
	eautoreconf
}

src_compile() {
	addpredict /dev/ppp

	cd "${S}/src"
	econf --enable-plugin=../../ppp-2.4.3 || die "econf failed"
	emake || die "emake failed"

	if use X; then
		make -C "${S}/gui" || die "gui make failed"
	fi
}

src_install () {
	cd "${S}/src"
	make RPM_INSTALL_ROOT="${D}" docdir=/usr/share/doc/${PF} install \
		|| die "install failed"

	#Don't use compiled rp-pppoe plugin - see pkg_preinst below
	rm "${D}/etc/ppp/plugins/rp-pppoe.so"

	prepalldocs

	if use X; then
		make -C "${S}/gui" install RPM_INSTALL_ROOT="${D}" \
		datadir=/usr/share/doc/${PF}/ || die "gui install failed"
		dosym /usr/share/doc/${PF}/tkpppoe /usr/share/tkpppoe
	fi
}

pkg_preinst() {
	# Use the rp-pppoe plugin that comes with net-dialup/pppd
	local PPPD_VER=`best_version net-dialup/ppp`
	PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%-*} #reduce it to ${PV}
	if [ -n "${PPPD_VER}" ] && [ -f "${ROOT}/usr/lib/pppd/${PPPD_VER}/rp-pppoe.so" ] ; then
		dosym /usr/lib/pppd/${PPPD_VER}/rp-pppoe.so /etc/ppp/plugins/rp-pppoe.so
	fi
}

pkg_postinst() {
	elog "Use pppoe-setup to configure your dialup connection."
}
