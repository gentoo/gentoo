# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign Wireshark releases"
HOMEPAGE="https://www.wireshark.org/download.html"
SRC_URI="https://www.wireshark.org/download/gerald_at_wireshark_dot_org.gpg -> ${P}-gerald-wireshark-org.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - wireshark.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
