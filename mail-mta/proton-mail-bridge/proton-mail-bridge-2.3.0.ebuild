# Copyright 1999-2022 Gentoo Authors
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

S="${WORKDIR}"/${MY_P}

src_prepare() {
	xdg_environment_reset
	default
}

src_compile() {
	if use gui; then
		emake \
			QT_DOC_DIR="/usr/share/qt5-doc" \
			QT_PKG_CONFIG=true \
			build
	else
		emake build-nogui
	fi
}

src_test() {
	emake test
}

src_install() {
	exeinto /usr/bin
	newexe ${MY_PN} ${PN}

	systemd_douserunit "${FILESDIR}"/${PN}.service

	# FIXME: USE=gui will probably need more files

	einstalldocs
}

pkg_postinst() {
	use gui && xdg_icon_cache_update
}

pkg_postrm() {
	use gui && xdg_icon_cache_update
}
