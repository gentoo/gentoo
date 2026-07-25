# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"D637032E45B8C6585B9456565D2EEE6F6F349D7C:tpm:manual,ubuntu"
)

inherit eapi9-pipestatus sec-keys

DESCRIPTION="OpenPGP keys used by Tim-Philipp Müller"
HOMEPAGE="https://gitlab.freedesktop.org/tpm"
SRC_URI+="
	https://gitlab.freedesktop.org/tpm.gpg -> ${P}-freedesktop.gpg
	https://github.com/tp-m.gpg -> ${P}-github.gpg
"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos ~x64-solaris"

src_test() {
	# manually check
	wget -qO- https://gitlab.freedesktop.org/tpm.gpg | gpg --import
	pipestatus || die

	wget -qO- https://github.com/tp-m.gpg | gpg --import
	pipestatus || die

	sec-keys_src_test
}
