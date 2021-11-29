# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="7232230911c02f81cb50b38f47ccf7100dd066f9"
inherit autotools linux-info systemd

DESCRIPTION="cifsd/ksmbd kernel server userspace utilities"
HOMEPAGE="https://github.com/cifsd-team/ksmbd-tools"
SRC_URI="https://github.com/cifsd-team/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${EGIT_COMMIT}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
# no keywords for now, for testing.
KEYWORDS=""

DEPEND="
	dev-libs/glib:2
	dev-libs/libnl:3
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

pkg_setup() {
	# we don't want to die() here to be able to build binpkgs
	kernel_is -lt 5 15 && eerror "kernel >=5.15 required for ${PN}"
	CONFIG_CHECK="~SMB_SERVER"
	# use krb5 && CONFIG_CHECK+=" ~SMB_SERVER_KERBEROS5"
	linux-info_pkg_setup
}

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	# TODO: add kerberos support, explicitly disable for now
	econf --enable-krb5=no
}

src_install() {
	default

	local DOCS=( README README.md Documentation/configuration.txt smb.conf.example )
	einstalldocs

	insinto /etc/ksmbd
	doins smb.conf.example

	# TODO: openrc service
	systemd_dounit ksmbd.service
}
