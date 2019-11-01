# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info systemd toolchain-funcs

DESCRIPTION="A simple daemon to control fan speed on all Macbook/Macbook Pros"
HOMEPAGE="https://github.com/dgraziotin/mbpfan"
LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test" # will fail if the hardware is unavailable, not useful

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dgraziotin/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/dgraziotin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

CONFIG_CHECK="~SENSORS_APPLESMC ~SENSORS_CORETEMP"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${ED}" install

	# Decompress the man page to enable PM auto compression
	gzip -d "${ED}"/usr/share/man/man8/mbpfan.8.gz || die

	# Remove the empty systemd unit directory
	# It doesn't actually install the unit file
	rmdir --ignore-fail-on-non-empty -p "${ED%/}/lib/systemd/system" || die
	# Actually install the sytstemd unit file
	systemd_dounit ${PN}.service
	# Install openrc init file
	newinitd ${PN}.init.gentoo ${PN}

	# make install doesn't install the docs in the right place
	rm -rf "${ED%/}/usr/share/doc/${PN}" || die

	einstalldocs
}
