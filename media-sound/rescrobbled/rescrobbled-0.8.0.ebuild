# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit cargo systemd

DESCRIPTION="MPRIS music scrobbler daemon"
HOMEPAGE="https://github.com/InputUsername/rescrobbled"
SRC_URI="https://github.com/InputUsername/rescrobbled/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~juippis/distfiles/rescrobbled-${PV}-crates.tar.xz"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-libs/openssl:=
	sys-apps/dbus"

QA_FLAGS_IGNORED="/usr/bin/rescrobbled"

src_install() {
	cargo_src_install
	einstalldocs

	# Fix path in the service file.
	sed -i "s|%h/.cargo/bin/rescrobbled|${EPREFIX}/usr/bin/rescrobbled|" "${S}"/rescrobbled.service || die
	systemd_dounit "${S}"/rescrobbled.service

	dodoc "${FILESDIR}"/config.toml
	docompress -x "/usr/share/doc/${PF}/config.toml"

	dodoc -r "${S}"/filter-script-examples
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Sample configuration file has been installed to "
		elog "  /usr/share/doc/rescrobbled-${PVR}/config.toml"
		elog ""
		elog "Use the sample, or launch rescrobbled to create a new empty one."
		elog ""
	fi
}
