# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="2ab5040d5633"
PYTHON_COMPAT=( python3_{10..13} )

inherit linux-info optfeature python-single-r1 toolchain-funcs

DESCRIPTION="A tool that can give numerous reports on memory usage on Linux systems"
HOMEPAGE="https://www.selenic.com/smem/"
SRC_URI="https://selenic.com/repo/${PN}/archive/${EGIT_COMMIT}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
BDEPEND="${RDEPEND}"

pkg_setup() {
	# CONFIG_PROC_PAGE_MONITOR is needed
	if linux-info_get_any_version && linux_config_src_exists ; then
		CONFIG_CHECK="PROC_PAGE_MONITOR"
		check_extra_config
	fi

	python-single-r1_pkg_setup
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
