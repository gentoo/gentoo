# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/resource-}"
inherit autotools multilib

DESCRIPTION="Resources pack for Heartbeat / Pacemaker"
HOMEPAGE="http://www.linux-ha.org/wiki/Resource_Agents"
SRC_URI="https://github.com/ClusterLabs/resource-agents/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="doc libnet rgmanager"

RDEPEND="sys-apps/iproute2
	>=sys-cluster/cluster-glue-1.0.12-r1
	libnet? ( net-libs/libnet:1.1 )"
DEPEND="${RDEPEND}
	doc? (
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
	)"

PATCHES=(
	"${FILESDIR}/4.6.1-configure.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-fatal-warnings \
		--localstatedir=/var \
		--with-ocf-root=/usr/$(get_libdir)/ocf \
		--with-rsctmpdir=/run/resource-agents \
		$(use_enable doc) \
		$(use_enable libnet)
}

src_install() {
	default
	rm -rf "${D}/usr/$(get_libdir)/ocf/resource.d/redhat" || die
	rm -rf "${D}"/etc/init.d/ || die
	rm -rf "${D}"{,/var}/run || die
	use rgmanager || rm -rf "${D}"/usr/share/cluster/ "${D}"/var/
}

pkg_postinst() {
	elog "To use Resource Agents installed in /usr/$(get_libdir)/ocf/resource.d"
	elog "you have to emerge required runtime dependencies manually."
	elog ""
	elog "Description and dependencies of all Agents can be found on"
	elog "http://www.linux-ha.org/wiki/Resource_Agents"
	elog "or in the documentation of this package."
}
