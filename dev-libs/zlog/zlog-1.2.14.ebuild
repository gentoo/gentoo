# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A reliable, thread safe, clear-model, pure C logging library."
HOMEPAGE="http://hardysimpson.github.io/zlog/"
SRC_URI="https://github.com/HardySimpson/${PN}/archive/${PV}.tar.gz -> ${PN}-v${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_test() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" test
}

src_install() {
	emake LIBRARY_PATH="$(get_libdir)" PREFIX="${D}/usr" install
}
