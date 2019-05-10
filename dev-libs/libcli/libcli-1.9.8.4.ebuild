# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

MY_PV="$(ver_rs 3 -)"

DESCRIPTION="Cisco-style (telnet) command-line interface library"

HOMEPAGE="https://github.com/dparrish/libcli"
SRC_URI="https://github.com/dparrish/libcli/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="static-libs"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}/${PN}-1.9.4-ldflags.patch"
	"${FILESDIR}/${PN}-1.9.8.4-libdir.patch"
)

src_compile() {
	emake OPTIM="" DEBUG="" \
		CC="$(tc-getCC)" AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" \
		libdir="/usr/$(get_libdir)" install

	dobin clitest
	dodoc README

	if ! use static-libs ; then
		find "${ED}" -type f -name "*.a" -delete || die
	fi
}
