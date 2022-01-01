# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/cluster-}"
inherit autotools eutils flag-o-matic multilib user

DESCRIPTION="Library pack for Heartbeat / Pacemaker"
HOMEPAGE="http://www.linux-ha.org/wiki/Cluster_Glue"
SRC_URI="http://hg.linux-ha.org/glue/archive/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="doc ipmilan libnet static-libs"

RDEPEND="
	app-arch/bzip2
	app-text/asciidoc
	app-text/docbook-xml-dtd:4.4
	dev-libs/glib:2
	dev-libs/libaio
	dev-libs/libltdl:=
	dev-libs/libxml2
	ipmilan? ( sys-libs/openipmi )
	libnet? ( net-libs/libnet:1.1 )
	net-misc/curl
	net-misc/iputils
	|| ( net-misc/netkit-telnetd net-misc/telnet-bsd )
"
DEPEND="${RDEPEND}
	doc? (
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
		)"

S="${WORKDIR}/Reusable-Cluster-Components-glue--${MY_P}"

pkg_setup() {
	enewgroup haclient
	enewuser  hacluster -1 -1 /var/lib/heartbeat haclient
}

src_prepare() {
	default
	sed -e 's/\\$(/$(/g' -e '/ -ggdb/d;/-fstack-protector-all/d' -i configure.ac || die
	sed -e "s@http://docbook.sourceforge.net/release/xsl/current@/usr/share/sgml/docbook/xsl-stylesheets/@g" \
		-i doc/Makefile.am || die
	eautoreconf
}

src_configure() {
	append-cppflags -DOPENIPMI_DEFINE_SELECTOR_T
	local myopts

	use doc && myopts=" --enable-doc"
	econf \
		$(use_enable ipmilan) \
		$(use_enable libnet) \
		$(use_enable static-libs static) \
		--disable-fatal-warnings \
		--localstatedir=/var \
		--with-ocf-root=/usr/$(get_libdir)/ocf \
		${myopts} \
		--with-group-id=$(id -g hacluster) \
		--with-ccmuser-id=$(id -u hacluster) \
		--with-daemon-user=hacluster --with-daemon-group=haclient
}

src_install() {
	default

	keepdir /var/lib/heartbeat/cores/{hacluster,nobody,root}
	keepdir /var/lib/heartbeat/lrm

	# init.d file
	cp "${FILESDIR}"/heartbeat-logd.init "${T}/" || die
	sed -i \
		-e "s:%libdir%:$(get_libdir):" \
		"${T}/heartbeat-logd.init" || die
# 	newinitd "${T}/heartbeat-logd.init" heartbeat-logd
	rm "${D}"/etc/init.d/logd

	use static-libs || find "${D}" -type f -name "*.la" -delete
}

pkg_postinst() {
	chown -R hacluster:haclient /var/lib/heartbeat/cores
	chown -R hacluster:haclient /var/lib/heartbeat/lrm
}
