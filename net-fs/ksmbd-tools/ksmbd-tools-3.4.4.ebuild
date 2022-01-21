# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info systemd

DESCRIPTION="cifsd/ksmbd kernel server userspace utilities"
HOMEPAGE="https://github.com/cifsd-team/ksmbd-tools"
SRC_URI="https://github.com/cifsd-team/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	dev-libs/glib:2
	dev-libs/libnl:3
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	# we don't want to die() here to be able to build binpkgs
	kernel_is -lt 5 15 && eerror "kernel >= 5.15 required for ${PN}"
	CONFIG_CHECK="~SMB_SERVER"
	ERROR_SMB_SERVER="CONFIG_SMB_SERVER is not set: ksmbd is not enabled in kernel, ${PN} will not work"
	# use krb5 && CONFIG_CHECK+=" ~SMB_SERVER_KERBEROS5"
	linux-info_pkg_setup
}

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	# TODO: add kerberos support, explicitly disable for now
	# tools are expected to recide in /sbin, not /usr/sbin
	econf --prefix="${EPREFIX}/" --enable-krb5=no
}

src_install() {
	default

	local DOCS=( README README.md Documentation/configuration.txt smb.conf.example )
	einstalldocs

	insinto /etc/ksmbd
	doins smb.conf.example

	newinitd "${FILESDIR}/initd" ksmbd
	newconfd "${FILESDIR}/confd" ksmbd

	dosym ksmbd.addshare /sbin/smbshareadd
	dosym ksmbd.adduser /sbin/smbuseradd

	systemd_dounit ksmbd.service
}
