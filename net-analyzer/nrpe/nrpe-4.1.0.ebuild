# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="Nagios Remote Plugin Executor"
HOMEPAGE="https://github.com/NagiosEnterprises/nrpe"
SRC_URI="https://github.com/NagiosEnterprises/nrpe/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="command-args selinux ssl tcpd"

DEPEND="acct-group/nagios
	acct-user/nagios
	tcpd? (
		sys-apps/tcp-wrappers
	)
	ssl? (
		dev-libs/openssl:=
	)"
RDEPEND="${DEPEND}
	|| ( net-analyzer/nagios-plugins net-analyzer/monitoring-plugins )
	selinux? ( sec-policy/selinux-nagios )"

PATCHES=(
	"${FILESDIR}/nrpe-3.2.1-eliminate-systemd-pid.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# The configure script tries to detect what OS, distribution, and
	# init system you're running and changes the build/install process
	# depending on what it comes up with. We specify fixed values
	# because we don't want it guessing, for example, whether or not
	# to install the tmpfiles.d entry based on whether or not systemd
	# is currently running (OpenRC uses them too).
	#
	# Note: upstream defaults to using "nagios" as the default NRPE
	# user and group. I have a feeling that this isn't quite correct
	# on a system where "nagios" is also the user running the nagios
	# server daemon. In the future, it would be nice if someone who
	# actually uses NRPE could test with an unprivileged "nrpe" as
	# the user and group.
	econf \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--localstatedir=/var/lib/nagios \
		--sysconfdir=/etc/nagios \
		--with-nrpe-user=nagios \
		--with-nrpe-group=nagios \
		--with-piddir=/run \
		--with-opsys=unknown \
		--with-dist-type=unknown \
		--with-init-type=unknown \
		--with-inetd-type=unknown \
		$(use_enable command-args) \
		$(use_enable ssl) \
		$(use_enable tcpd)
}

src_compile() {
	emake all
}

src_install() {
	default

	dodoc CHANGELOG.md SECURITY.md
	insinto /etc/nagios
	newins sample-config/nrpe.cfg nrpe.cfg
	fowners root:nagios /etc/nagios/nrpe.cfg
	fperms 0640 /etc/nagios/nrpe.cfg

	newinitd "startup/openrc-init" nrpe
	newconfd "startup/openrc-conf" nrpe
	systemd_newunit "startup/default-service" "${PN}.service"

	insinto /etc/xinetd.d/
	newins "${FILESDIR}/nrpe.xinetd.2" nrpe

	rm "${ED}/usr/bin/nrpe-uninstall" || die 'failed to remove uninstall tool'
	rm -r "${ED}/run" || die 'failed to remove /run'
}

pkg_postinst() {
	if use command-args ; then
		ewarn ''
		ewarn 'You have enabled command-args for NRPE. That lets clients'
		ewarn 'supply arguments to the commands that are run, and IS A'
		ewarn 'SECURITY RISK!'
		ewarn ''
	fi
}
