# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="File format designed for highly efficient deltas with good compression"
HOMEPAGE="https://github.com/zchunk/zchunk"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zchunk/zchunk.git"
else
	SRC_URI="https://github.com/zchunk/zchunk/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2"
SLOT="0"

DEPEND="
	app-arch/zstd:=
	net-misc/curl
	dev-libs/openssl:=
"
RDEPEND="${DEPEND}"
