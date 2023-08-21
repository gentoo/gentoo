# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd xdg-utils

MY_PN="${PN/-mail/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Serves ProtonMail to IMAP/SMTP clients"
HOMEPAGE="https://proton.me/mail/bridge https://github.com/ProtonMail/proton-bridge/"
SRC_URI="https://github.com/ProtonMail/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~marecki/dists/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 GPL-3+ ISC LGPL-3+ MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gui"

# Quite a few tests require Internet access
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="app-crypt/libsecret"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.2-telemetry_default.patch
)

S="${WORKDIR}"/${MY_P}

src_prepare() {
	xdg_environment_reset
	default
}

src_compile() {
	if use gui; then
		eerror "Since version 3.0.0, GUI support in ${PN} requires Qt6 and is therefore currently not available"
		die "USE=gui requires Qt6"
	else
		emake build-nogui
	fi
}

src_test() {
	emake test
}

src_install() {
	exeinto /usr/bin
	newexe bridge ${PN}

	systemd_newuserunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service

	einstalldocs
}

pkg_postinst() {
	use gui && xdg_icon_cache_update

	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		local oldver
		for oldver in ${REPLACING_VERSIONS}; do
			if ver_test "${oldver}" -lt 3.2.0; then
				ewarn "Please note that since version 3.2.0, ${PN} can share usage statistics with upstream."
				ewarn "For details, please see"
				ewarn
				ewarn "	https://proton.me/support/share-usage-statistics"
				ewarn
				ewarn "Gentoo ebuilds change the default value of the 'send telemetry' setting to disabled."
				ewarn
				break
			fi
		done
	fi
}

pkg_postrm() {
	use gui && xdg_icon_cache_update
}
