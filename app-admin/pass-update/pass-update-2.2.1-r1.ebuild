# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/roddhjav.asc
inherit shell-completion verify-sig

DESCRIPTION="pass extension that provides an easy flow for updating passwords"
HOMEPAGE="https://github.com/roddhjav/pass-update"
SRC_URI="
	https://github.com/roddhjav/pass-update/releases/download/v${PV}/${P}.tar.gz
	verify-sig? ( https://github.com/roddhjav/pass-update/releases/download/v${PV}/${P}.tar.gz.asc )
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-admin/pass-1.7.0
"
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-roddhjav )
"

src_test() {
	emake TMP="${T}" tests
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		BASHCOMPDIR="$(get_bashcompdir)" \
		ZSHCOMPDIR="$(get_zshcompdir)" \
		install

	# https://github.com/roddhjav/pass-update/issues/25
	rm -r "${ED}"/usr/share/bash-completion || die
	insinto /etc/bash_completion.d
	doins share/bash-completion/completions/pass-update
}
