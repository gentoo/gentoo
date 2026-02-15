# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Idle management daemon for Wayland"
HOMEPAGE="https://github.com/swaywm/swayidle"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
	inherit verify-sig
	SRC_URI="https://github.com/swaywm/${PN}/releases/download/v${PV}/${P}.tar.gz
		https://github.com/swaywm/${PN}/releases/download/v${PV}/${P}.tar.gz.sig"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="elogind systemd"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	dev-libs/wayland
	elogind? ( >=sys-auth/elogind-237[policykit] )
	systemd? ( >=sys-apps/systemd-237[policykit] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/scdoc
	>=dev-util/wayland-scanner-1.14.91
	>=dev-libs/wayland-protocols-1.27
	virtual/pkgconfig
"

if [[ ${PV} != 9999 ]]; then
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-emersion )"
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"
fi

src_configure() {
	local emesonargs=(
		-Dman-pages=enabled
		-Dfish-completions=true
		-Dzsh-completions=true
		-Dbash-completions=true
	)
	if use systemd; then
		emesonargs+=("-Dlogind=enabled" "-Dlogind-provider=systemd")
	elif use elogind; then
		emesonargs+=("-Dlogind=enabled" "-Dlogind-provider=elogind")
	else
		emesonargs+=("-Dlogind=disabled")
	fi

	meson_src_configure
}
