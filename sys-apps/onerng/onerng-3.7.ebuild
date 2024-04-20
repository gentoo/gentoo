# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/-/_}"
PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1 udev

DESCRIPTION="Software for the Open Hardware Random Number Generator called OneRNG"
HOMEPAGE="https://www.onerng.info/"
SRC_URI="https://github.com/OneRNG/onerng.github.io/raw/master/sw/${MY_P}.orig.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="virtual/pkgconfig"

DEPEND="virtual/udev"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	app-crypt/gnupg
	$(python_gen_cond_dep 'dev-python/python-gnupg[${PYTHON_USEDEP}]')
	sys-apps/rng-tools
	sys-process/at
"

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
