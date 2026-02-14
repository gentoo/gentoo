# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Key isn't in a convenient format to download on their website
# https://handbrake.fr/openpgp.php

SEC_KEYS_VALIDPGPKEYS=(
	# opengpg cannot be used due to missing user ID's
	"1629C061B3DDE7EB4AE34B81021DB8B44E4A8645:handbrake:ubuntu"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign HandBrake"
HOMEPAGE="https://handbrake.fr/"

KEYWORDS="amd64 ~arm64 ~x86"
