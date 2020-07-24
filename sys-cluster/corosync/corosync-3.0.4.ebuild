# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="OSI Certified implementation of a complete cluster engine"
HOMEPAGE="http://www.corosync.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="doc systemd xml dbus"

# TODO: support those new configure flags
# --enable-augeas : Install the augeas lens for corosync.conf
# --enable-snmp : SNMP protocol support
# --enable-watchdog : Watchdog support
RDEPEND="dev-libs/nss
	>=sys-cluster/libqb-2.0.0:=
	sys-cluster/kronosnet:=
	dbus? ( sys-apps/dbus )
	systemd? ( sys-apps/systemd:= )
	"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( sys-apps/groff )"

DOCS=( README.recovery AUTHORS )

src_prepare() {
	default

	sed -i 's/$SEC_FLAGS $OPT_CFLAGS $GDB_FLAGS/$OS_CFLAGS/' configure.ac || die 'sed failed'

	if ! use doc; then
		sed -i 's/BUILD_HTML_DOCS, test/BUILD_HTML_DOCS, false/' configure.ac || die 'sed failed'
	fi

	eautoreconf
}

src_configure() {
	# appends lib to localstatedir automatically
	# FIXME: install just shared libs --disable-static does not work
	econf_opts=(
		--disable-static \
		--localstatedir=/var \
		$(use_enable dbus) \
		$(use_enable systemd) \
		$(use_enable xml xmlconf)
	)
	use doc && econf_opts+=( --enable-doc )
	econf "${econf_opts[@]}"
}

src_install() {
	default
	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	keepdir /var/lib/corosync /var/log/cluster

	find "${D}" -name '*.la' -delete || die
}
