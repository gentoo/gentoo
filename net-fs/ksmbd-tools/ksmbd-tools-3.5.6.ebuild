# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson systemd

DESCRIPTION="cifsd/ksmbd kernel server userspace utilities"
HOMEPAGE="https://github.com/cifsd-team/ksmbd-tools"
SRC_URI="https://github.com/cifsd-team/ksmbd-tools/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
IUSE="kerberos"

DEPEND="
	>=dev-libs/glib-2.58:2
	dev-libs/libnl:3
	kerberos? ( virtual/krb5 )
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/ksmbd-tools-3.5.6-systemd-network-online.patch"
)

pkg_setup() {
	# we don't want to die() here to be able to build binpkgs
	kernel_is -lt 5 15 && eerror "kernel >= 5.15 required for ${PN}"
	CONFIG_CHECK="~SMB_SERVER"
	ERROR_SMB_SERVER="CONFIG_SMB_SERVER is not set: ksmbd is not enabled in kernel, ${PN} will not work"
	use kerberos && CONFIG_CHECK+=" ~SMB_SERVER_KERBEROS5"
	linux-info_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Drundir="${EPREFIX}"/run
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(meson_feature kerberos krb5)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	local DOCS=( README.md ksmbd.conf.example )
	einstalldocs

	newinitd "${FILESDIR}/ksmbd.initd-r1" ksmbd
	newconfd "${FILESDIR}/ksmbd.confd" ksmbd
}
