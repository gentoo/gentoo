# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for LevelDB versions known to be compatible with Bitcoin Core 0.9+"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	|| (
		=dev-libs/leveldb-1.20
		=dev-libs/leveldb-1.18-r2
		=dev-libs/leveldb-1.18
		=dev-libs/leveldb-1.17
		=dev-libs/leveldb-1.15.0-r1
	)"
