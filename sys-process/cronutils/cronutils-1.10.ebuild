# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Utilities to assist running batch processing jobs"
HOMEPAGE="https://github.com/google/cronutils"
SRC_URI="https://github.com/google/${PN}/archive/version/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-version-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="-D_XOPEN_SOURCE=500 ${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
}
