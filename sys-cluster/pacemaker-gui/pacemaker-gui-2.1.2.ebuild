# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="2"
MY_P="pacemaker-mgmt-${PV}"
MY_TREE="3c95739"

inherit python base autotools

DESCRIPTION="Pacemaker python GUI and management daemon"
HOMEPAGE="http://hg.clusterlabs.org/pacemaker/pygui/"
SRC_URI="https://github.com/gao-yan/pacemaker-mgmt/tarball/${MY_P} -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="-gtk heartbeat nls snmp static-libs"

CDEPEND="
	app-arch/bzip2
	dev-libs/glib:2
	dev-libs/libxslt
	dev-libs/openssl
	net-libs/gnutls
	sys-apps/util-linux
	sys-cluster/cluster-glue
	>=sys-cluster/pacemaker-1.1
	heartbeat? ( sys-cluster/pacemaker[heartbeat] )
	gtk? (
		dev-python/pygtk
		)
	sys-libs/ncurses
	sys-libs/pam
	sys-libs/zlib"
RDEPEND="${CDEPEND}
	sys-devel/libtool"
DEPEND="${CDEPEND}
	gtk? ( dev-lang/swig )
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

S="${WORKDIR}/gao-yan-pacemaker-mgmt-${MY_TREE}"

PATCHES=(
	"${FILESDIR}/${PN}-2.1.1-doc.patch"
)

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	base_src_prepare
	# FIXME upstream said they will find a way to avoid this patch
	if has_version ">sys-cluster/pacemaker-1.1.8"; then
		epatch "${FILESDIR}"/pacemaker-mgmt-query-node-uuid.patch
	fi
	eautoreconf
}

src_configure() {
	local myopts=""
	use heartbeat || myopts="--with-ais-support"
	econf $(use_with heartbeat heartbeat-support) \
		$(use_enable snmp) \
		$(use_enable nls) \
		$(use_enable gtk mgmt-client) \
		$(use_enable static-libs static) \
		${myopts} \
		--disable-fatal-warnings
}

src_install() {
	base_src_install
	use static-libs || find "${D}"/usr/$(get_libdir)/ -name "*.la" -delete
	dodoc README doc/AUTHORS || die
}

pkg_postinst() {
	elog "IMPORTANT: To have the mgmtd daemon started with your cluster,"
	elog "you must add this directive in /etc/corosync/service.d/pacemaker :"
	elog ""
	elog "use_mgmtd: 1"
	elog ""
	elog "NB: To access the GUI, your user must be part of the 'haclient' group"
}
