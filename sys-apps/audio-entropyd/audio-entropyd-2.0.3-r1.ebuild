# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="Audio-entropyd generates entropy-data for the /dev/random device"
HOMEPAGE="https://vanheusden.com/crypto/entropy/aed/"
SRC_URI="https://vanheusden.com/crypto/entropy/aed/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="selinux"

DEPEND="media-libs/alsa-lib:="
RDEPEND="${DEPEND}
	media-sound/alsa-utils
	selinux? ( sec-policy/selinux-entropyd )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.1-uclibc.patch
	"${FILESDIR}"/${PN}-2.0.1-ldflags.patch
)

src_prepare() {
	default

	sed -i -e "s|^OPT_FLAGS=.*|OPT_FLAGS=${CFLAGS}|" \
		-e "/^WARNFLAGS/s: -g::" Makefile || die
}

src_configure() {
	tc-export CC
}

src_install() {
	dosbin audio-entropyd
	einstalldocs

	systemd_dounit "${FILESDIR}"/${PN}.service
	newinitd "${FILESDIR}"/${PN}.init-2 ${PN}
	newconfd "${FILESDIR}"/${PN}.conf-2 ${PN}
}
