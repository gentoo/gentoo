# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="TPM2 Access Broker & Resource Manager"
HOMEPAGE="https://github.com/tpm2-software/tpm2-abrmd"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs test"

RESTRICT="!test? ( test )"

RDEPEND="sys-apps/dbus:=
	dev-libs/glib:=
	app-crypt/tpm2-tss:="
DEPEND="${RDEPEND}
	acct-group/tss
	acct-user/tss
	test? ( dev-util/cmocka )"
BDEPEND="virtual/pkgconfig
	dev-util/gdbus-codegen"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable test unit) \
		--disable-defaultflags \
		--with-dbuspolicydir="${EPREFIX}/etc/dbus-1/system.d" \
		--with-systemdpresetdir="$(systemd_get_systemunitdir)/../system-preset" \
		--with-systemdpresetdisable \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
