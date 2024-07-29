# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop fcaps prefix unpacker xdg

DESCRIPTION="Microsoft Azure VPN client for connecting securely to the Azure cloud"
HOMEPAGE="https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-certificate-client-linux-azure-vpn-client"
SRC_URI="https://packages.microsoft.com/ubuntu/22.04/prod/pool/main/${PN:0:1}/${PN}/${PN}_${PV}_amd64.deb"
S="${WORKDIR}"
LICENSE="microsoft-azurevpnclient Apache-2.0 BSD-2 BSD ISC MIT openssl SSLeay"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

RDEPEND="
	app-accessibility/at-spi2-core:2
	app-crypt/libsecret
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/openssl:0/3
	media-libs/fontconfig:1.0
	media-libs/libepoxy
	net-misc/curl
	sys-apps/systemd[resolvconf]
	sys-auth/polkit
	sys-auth/polkit-pkla-compat
	sys-libs/libcap
	sys-libs/zlib
	x11-libs/gtk+:3
	x11-libs/pango
	prefix? ( dev-util/patchelf )
"

PATCHES=(
	"${FILESDIR}"/${PN}-sudo-group.patch
)

QA_PREBUILT="*"
DIR="/opt/microsoft/${PN}"

src_unpack() {
	unpack_deb ${A}
}

src_configure() {
	hprefixify \
		etc/rsyslog.d/*.conf \
		usr/share/applications/*.desktop \
		usr/share/polkit-1/rules.d/*.rules

	if use prefix; then
		patchelf --set-rpath "${EPREFIX}${DIR}/lib" "${DIR#/}"/{lib/*,${PN}} || die
	fi
}

src_install() {
	insinto "${DIR}"
	doins -r "${DIR#/}"/data

	exeinto "${DIR}"/lib
	doexe "${DIR#/}"/lib/*

	exeinto "${DIR}"
	doexe "${DIR#/}"/${PN}
	dosym "../../${DIR#/}/${PN}" /usr/bin/${PN}

	insinto /usr/share/polkit-1
	doins -r usr/share/polkit-1/*

	insinto /var/lib/polkit-1
	doins -r var/lib/polkit-1/*

	insinto /etc
	doins -r etc/*

	domenu usr/share/applications/*.desktop
	insinto /usr/share/icons
	doins usr/share/icons/*.png

	gunzip usr/share/doc/${PN}/changelog.gz || die
	dodoc usr/share/doc/${PN}/changelog
}

pkg_postinst() {
	fcaps cap_net_admin+eip "${EROOT}${DIR}/${PN}"
	xdg_pkg_postinst
}
