# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	FE66471B43559707AFDAD955DE7A44FAC7FB382D:lyx:openpgp,ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by app-office/lyx"
HOMEPAGE="https://www.lyx.org/Download#signing"

SLOT="0"
KEYWORDS="amd64 ~arm64"
