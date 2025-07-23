# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scsitape/stenc.git"
	S="${WORKDIR}/${P}/src"
else
	SRC_URI="https://github.com/scsitape/stenc/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="SCSI Tape Encryption Manager enables AES support for LTO drives"
HOMEPAGE="https://github.com/scsitape/stenc/"

LICENSE="GPL-2"
SLOT="0"

BDEPEND="
	virtual/pandoc
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}
