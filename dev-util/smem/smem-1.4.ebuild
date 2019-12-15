# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 toolchain-funcs

DESCRIPTION="A tool that can give numerous reports on memory usage on Linux systems"
HOMEPAGE="https://www.selenic.com/smem/"
SRC_URI="https://www.selenic.com/${PN}/download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
BDEPEND="${RDEPEND}"

src_prepare() {
	default

	python_fix_shebang smem
}

src_compile() {
	"$(tc-getCC)" ${CFLAGS} ${LDFLAGS} -o smemcap smemcap.c || die
}

src_install() {
	dobin smemcap
	python_doexe smem

	doman smem.8
}

pkg_postinst() {
	optfeature "for chart generation." dev-python/matplotlib
}
