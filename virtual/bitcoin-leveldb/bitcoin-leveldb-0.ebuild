# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Virtual for LevelDB versions known to be compatible with Bitcoin Core 0.9+"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 x86 amd64-linux x86-linux"

DEPEND=""
RDEPEND="
	|| (
		=dev-libs/leveldb-1.15.0-r1
		=dev-libs/leveldb-1.17
		=dev-libs/leveldb-1.18
		=dev-libs/leveldb-1.18-r1
	)"
