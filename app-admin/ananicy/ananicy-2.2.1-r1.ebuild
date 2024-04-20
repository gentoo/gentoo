# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit python-single-r1

DESCRIPTION="ANother Auto NICe daemon"
HOMEPAGE="https://github.com/Nefelim4ag/Ananicy"
SRC_URI="https://github.com/Nefelim4ag/Ananicy/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sys-process/schedtool"
BDEPEND="${PYTHON_DEPS}"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/${PN}-fix-sysctl-path.patch"
)

src_compile() {
	return
}

src_install() {
	emake PREFIX="${D}" install

	python_fix_shebang "${ED}"/usr/bin/ananicy
	doinitd "${FILESDIR}"/ananicy.initd

	einstalldocs
}
