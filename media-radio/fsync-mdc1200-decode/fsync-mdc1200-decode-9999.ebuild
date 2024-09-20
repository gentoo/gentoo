# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Linux Fleetsync / MDC1200 decoder"
HOMEPAGE="https://github.com/russinnes/fsync-mdc1200-decode"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/russinnes/fsync-mdc1200-decode.git"
else
	SRC_URI="https://github.com/russinnes/fsync-mdc1200-decode/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DEPEND="media-libs/libpulse"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	$(tc-getCC) -o fsync-mdc1200-decode ${CFLAGS} ${LDFLAGS} demod.c fsync_decode.c \
		mdc_decode.c $($(tc-getPKG_CONFIG) --cflags --libs libpulse-simple)
}

src_install() {
	dobin fsync-mdc1200-decode
}
