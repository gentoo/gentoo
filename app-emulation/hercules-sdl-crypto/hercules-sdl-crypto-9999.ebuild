# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

DESCRIPTION="Simple AES/DES encryption and SHA1/SHA2 hashing library"
HOMEPAGE="https://github.com/SDL-Hercules-390/crypto"
EGIT_REPO_URI="https://github.com/SDL-Hercules-390/crypto"

LICENSE="public-domain MIT BSD"
SLOT="0"
PATCHES=( "${FILESDIR}/cmakefix.patch" )
