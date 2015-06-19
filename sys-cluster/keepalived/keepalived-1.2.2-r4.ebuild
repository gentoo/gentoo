# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/keepalived/keepalived-1.2.2-r4.ebuild,v 1.5 2012/09/15 18:37:35 armin76 Exp $

EAPI=4

inherit autotools base

DESCRIPTION="A strong & robust keepalive facility to the Linux Virtual Server project"
HOMEPAGE="http://www.keepalived.org/"
DEBIAN_PATCH=3
DEBIAN_A="${P/-/_}-${DEBIAN_PATCH}.diff.gz"
SRC_URI="http://www.keepalived.org/software/${P}.tar.gz
		mirror://debian/pool/main/${PN:0:1}/${PN}/${DEBIAN_A}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 s390 sparc x86"
IUSE="debug ipv6"

RDEPEND="dev-libs/popt
	sys-apps/iproute2
	dev-libs/libnl:1.1
	dev-libs/openssl"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.30"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.20-do-not-need-kernel-sources.patch
	"${FILESDIR}"/${PN}-1.2.2-bind-afunspec.patch
	"${FILESDIR}"/${PN}-1.2.2-fix-ipv4-addr-compare.patch
	"${FILESDIR}"/${PN}-1.2.2-libipvs-fix-backup-daemon.patch
)

DOCS=( README CONTRIBUTORS INSTALL VERSION ChangeLog AUTHOR TODO doc/keepalived.conf.SYNOPSIS )

src_prepare() {
	base_src_prepare
	EPATCH_OPTS="-p1" epatch "${DISTDIR}"/"${DEBIAN_A}"
	epatch "${S}"/debian/patches/*patch
	use ipv6 && epatch "${FILESDIR}"/${PN}-1.2.2-libipvs-fix-ipv6.patch
	eautoreconf
}

src_configure() {
	STRIP=/bin/true \
	econf \
		--enable-vrrp \
		$(use_enable debug)
}

src_install() {
	default

	newinitd "${FILESDIR}"/init-keepalived keepalived
	newconfd "${FILESDIR}"/conf-keepalived keepalived

	docinto genhash
	dodoc genhash/README genhash/AUTHOR genhash/ChangeLog genhash/VERSION || die
	# This was badly named by upstream, it's more HOWTO than anything else.
	newdoc INSTALL INSTALL+HOWTO

	# Security risk to bundle SSL certs
	rm -f "${ED}"/etc/keepalived/samples/*.pem
	# Clean up sysvinit files
	rm -rf "${ED}"/etc/sysconfig "${ED}"/etc/rc.d/
}
