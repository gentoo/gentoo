# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver linux-info meson systemd

DESCRIPTION="cifsd/ksmbd kernel server userspace utilities"
HOMEPAGE="https://github.com/cifsd-team/ksmbd-tools"
SRC_URI="https://github.com/cifsd-team/ksmbd-tools/releases/download/${PV}/${P}.tar.gz"

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

src_configure() {
	local emesonargs=(
		-Drundir="${EPREFIX}"/run
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		# TODO: add kerberos support, explicitly disable for now
		-Dkrb5=disabled
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	local DOCS=( README.md ksmbd.conf.example )
	einstalldocs

	insinto /etc/ksmbd
	doins ksmbd.conf.example

	newinitd "${FILESDIR}/ksmbd.initd-r1" ksmbd
	newconfd "${FILESDIR}/ksmbd.confd" ksmbd

	dosym ksmbd.addshare /usr/sbin/smbshareadd
	dosym ksmbd.adduser /usr/sbin/smbuseradd
}

pkg_postinst() {
	if ver_replacing -lt 3.4.6; then
		ewarn "Upgrade from version <${CATEGORY}/${PN}-3.4.6 detected"
		ewarn "${PN} config file moved to ${EPREFIX}/etc/ksmbd/ksmbd.conf"
		ewarn "Please migrate from old ${EPREFIX}/etc/ksmbd/smb.conf"
	fi
}
