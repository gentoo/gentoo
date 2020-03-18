# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Large collection of LV2 audio plugins/effects"
HOMEPAGE="http://plugin.org.uk/"
SRC_URI="https://github.com/swh/lv2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sci-libs/fftw:3.0"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	virtual/pkgconfig"

S="${WORKDIR}/lv2-${PV}"

src_prepare() {
	sed -e 's:-O3 -fomit-frame-pointer -fstrength-reduce -funroll-loops::g' \
		-i Makefile || die
	default
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	emake INSTALL_DIR="${D}/usr/$(get_libdir)/lv2" install-system
	dodoc README
}
