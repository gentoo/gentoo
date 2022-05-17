# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="TPM2 Access Broker & Resource Manager"
HOMEPAGE="https://github.com/tpm2-software/tpm2-abrmd"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE="static-libs test"

RESTRICT="!test? ( test )"

RDEPEND="acct-group/tss
	acct-user/tss
	sys-apps/dbus
	dev-libs/glib:=
	app-crypt/tpm2-tss:="
DEPEND="${RDEPEND}
	test? (
		app-crypt/swtpm
		>=app-crypt/tpm2-tss-3.0.0:=
		dev-util/cmocka
	)"
BDEPEND="virtual/pkgconfig
	dev-util/gdbus-codegen"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable test unit) \
		$(use_enable test integration) \
		--disable-defaultflags \
		--with-dbuspolicydir="${EPREFIX}/etc/dbus-1/system.d" \
		--with-systemdpresetdir="$(systemd_get_systemunitdir)/../system-preset" \
		--with-systemdpresetdisable \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
}

src_install() {
	default

	if [[ ${PV} != $(sed -n -e 's/^Version: //p' "${ED}/usr/$(get_libdir)/pkgconfig/tss2-tcti-tabrmd.pc" || die) ]] ; then
		# Safeguard for bug #833887
		die "pkg-config file version doesn't match ${PV}! Please report a bug!"
	fi

	find "${D}" -name '*.la' -delete || die

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
