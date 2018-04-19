# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A general purpose fuzzer with feedback support"
HOMEPAGE="http://google.github.io/honggfuzz/"
SRC_URI="https://github.com/google/honggfuzz/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	sys-libs/binutils-libs:=
	sys-libs/libunwind
"

DEPEND="${RDEPEND}"

DOCS=(
	CHANGELOG
	COPYING
	CONTRIBUTING
	README.md
)

src_prepare() {
	default
	if has_version ">=sys-libs/binutils-libs-2.29"; then
		eapply "${FILESDIR}"/${PN}-1.1-binutils-2.29.patch
	fi
}

src_compile() {
	CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" emake
}

src_install() {
	dobin ${PN}

	einstalldocs
}
