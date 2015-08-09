# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

MY_P="${P/resource-}"
inherit autotools multilib eutils base

DESCRIPTION="Resources pack for Heartbeat / Pacemaker"
HOMEPAGE="http://www.linux-ha.org/wiki/Resource_Agents"
SRC_URI="http://hg.linux-ha.org/agents/archive/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE="doc libnet"

DEPEND="sys-apps/iproute2
	sys-cluster/cluster-glue
	!<sys-cluster/heartbeat-3.0
	libnet? ( net-libs/libnet:1.1 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Cluster-Resource-Agents-${MY_P}"

PATCHES=(
	"${FILESDIR}/1.0.3-docs.patch"
	"${FILESDIR}/1.0.3-respect_cflags.patch"
	"${FILESDIR}/1.0.4-dosymlinks.patch"
)

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-fatal-warnings \
		--localstatedir=/var \
		--docdir=/usr/share/doc/${PF} \
		--libdir=/usr/$(get_libdir) \
		--with-ocf-root=/usr/$(get_libdir)/ocf \
		$(use_enable doc) \
		$(use_enable libnet)
}

src_install() {
	base_src_install
	rm -rf "${D}"/etc/init.d/ldirectord || die
}

pkg_postinst() {
	elog "To use Resource Agents installed in /usr/$(get_libdir)/ocf/resource.d"
	elog "you have to emerge required runtime dependencies manually."
	elog ""
	elog "Description and dependencies of all Agents can be found on"
	elog "http://www.linux-ha.org/wiki/Resource_Agents"
	elog "or in the documentation of this package."
}
