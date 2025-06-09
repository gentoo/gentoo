# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson verify-sig

DESCRIPTION="Collection of QA scripts for ebuild development"
HOMEPAGE="https://codeberg.org/eli-schwartz/eschwartz-dev-scripts"
SRC_URI="
	https://codeberg.org/eli-schwartz/eschwartz-dev-scripts/releases/download/${PV}/${P}.tar.xz
	verify-sig? ( https://codeberg.org/eli-schwartz/eschwartz-dev-scripts/releases/download/${PV}/${P}.tar.xz.asc )
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc64"

RDEPEND="
	sys-apps/portage
"
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-eschwartz )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/eschwartz.gpg
