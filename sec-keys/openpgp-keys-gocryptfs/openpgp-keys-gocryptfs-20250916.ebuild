# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"FFF3E01444FED7C316A3545A895F5BC123A02740:nuetzlich-gocryptfs-signing-key:ubuntu,manual"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign gocryptfs"
HOMEPAGE="https://nuetzlich.net/"
SRC_URI+="https://nuetzlich.net/gocryptfs-signing-key.pub -> ${PN}-nuetzlich-gocryptfs-signing-key-${PV}.pub"

KEYWORDS="~amd64 ~ppc64 ~x86"
