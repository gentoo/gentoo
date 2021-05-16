# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info autotools

DESCRIPTION="OSI Certified implementation of a complete cluster engine"
HOMEPAGE="http://www.corosync.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2 public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 x86"
IUSE="augeas dbus doc snmp systemd watchdog xml"

RDEPEND="dev-libs/nss
	>=sys-cluster/libqb-2.0.0:=
	sys-cluster/kronosnet:=
	augeas? ( app-admin/augeas )
	dbus? ( sys-apps/dbus )
	snmp? ( net-analyzer/net-snmp )
	systemd? ( sys-apps/systemd:= )
	watchdog? ( sys-kernel/linux-headers )
	"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( sys-apps/groff )"

DOCS=( README.recovery AUTHORS )

pkg_setup() {
	if use watchdog; then
		# verify that CONFIG_WATCHDOG is enabled in the kernel or
		# warn otherwise
		linux-info_pkg_setup
		elog "Checking for suitable kernel configuration options..."
		if linux_config_exists; then
			if ! linux_chkconfig_present WATCHDOG; then
				ewarn "CONFIG_WATCHDOG: is not set when it should be."
				elog "Please check to make sure these options are set correctly."
			fi
		else
				ewarn "Could not check, if CONFIG_WATCHDOG is enabled in your kernel."
				elog "Please check to make sure these options are set correctly."
		fi
	fi
}

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
		$(use_enable augeas) \
		$(use_enable dbus) \
		$(use_enable snmp) \
		$(use_enable systemd) \
		$(use_enable watchdog) \
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

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} ]]; then
		elog "Default token timeout was changed from 1 seconds to 3 seconds."
		elog "If you need to keep the old timeout, add 'token: 1000' to the"
		elog "totem {} section of your corosync.conf"
	fi
}
