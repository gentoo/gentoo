# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="InstallShield CAB file extractor"
HOMEPAGE="https://github.com/twogood/unshield"
SRC_URI="https://github.com/twogood/unshield/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv x86"

# OpenSSL is detected at build time, and used to determine
# whether or not a hand-rolled md5 implementation is used. The build
# system prefers OpenSSL's implementation if it's available, and OpenSSL
# is common enough, so we prefer it too. Since the dependency is
# automagic (there's no way to hide it), we require OpenSSL
# unconditionally.

DEPEND="
	dev-libs/openssl:0=
	sys-libs/zlib"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-mandir.patch" )
