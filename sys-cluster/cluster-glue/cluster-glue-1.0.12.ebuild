# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/cluster-}"
inherit autotools eutils multilib user

DESCRIPTION="Library pack for Heartbeat / Pacemaker"
HOMEPAGE="http://www.linux-ha.org/wiki/Cluster_Glue"
SRC_URI="http://hg.linux-ha.org/glue/archive/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="doc libnet static-libs"

RDEPEND="app-text/asciidoc
	app-arch/bzip2
	app-text/docbook-xml-dtd:4.4
	dev-libs/glib:2
	dev-libs/libaio
	libnet? ( net-libs/libnet:1.1 )
	net-misc/curl
	net-misc/iputils
	|| ( net-misc/netkit-telnetd net-misc/telnet-bsd )
	dev-libs/libxml2
	!<sys-cluster/heartbeat-3.0"
DEPEND="${RDEPEND}
	doc? (
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
		)"

S="${WORKDIR}/Reusable-Cluster-Components-glue--${MY_P}"

pkg_setup() {
	enewgroup haclient
	enewuser  hacluster -1 /dev/null /var/lib/heartbeat haclient
}

src_prepare() {
	default
	sed -e '/ -ggdb/d' -i configure.ac || die
	sed -e "s@http://docbook.sourceforge.net/release/xsl/current@/usr/share/sgml/docbook/xsl-stylesheets/@g" \
		-i doc/Makefile.am || die
	eautoreconf
}

src_configure() {
	local myopts

	use doc && myopts=" --enable-doc"
	econf \
		$(use_enable libnet) \
		$(use_enable static-libs static) \
		--disable-fatal-warnings \
		--disable-dependency-tracking \
		--docdir=/usr/share/doc/${PF} \
		--localstatedir=/var \
		--with-ocf-root=/usr/$(get_libdir)/ocf \
		${myopts} \
		--with-group-id=$(id -g hacluster) \
		--with-ccmuser-id=$(id -u hacluster) \
		--with-daemon-user=hacluster --with-daemon-group=haclient
}

src_install() {
	default

	dodir /var/lib/heartbeat/cores
	dodir /var/lib/heartbeat/lrm

	keepdir /var/lib/heartbeat/cores
	keepdir /var/lib/heartbeat/lrm

	# init.d file
	cp "${FILESDIR}"/heartbeat-logd.init "${T}/" || die
	sed -i \
		-e "s:%libdir%:$(get_libdir):" \
		"${T}/heartbeat-logd.init" || die
# 	newinitd "${T}/heartbeat-logd.init" heartbeat-logd || die
	rm "${D}"/etc/init.d/logd

	use static-libs || find "${D}" -type f -name "*.la" -delete
}

pkg_postinst() {
	chown -R hacluster:haclient /var/lib/heartbeat/cores
	chown -R hacluster:haclient /var/lib/heartbeat/lrm
}
