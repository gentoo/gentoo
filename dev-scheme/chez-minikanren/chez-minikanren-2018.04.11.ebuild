# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: miniKanren does not define a library interface :(
# so we will make a wrapper to load miniKanren...

EAPI=8

COMMIT=2d50ec5002fe052f5c2f2d72530dcbeb8760fde8
MY_PN=miniKanren

inherit wrapper

DESCRIPTION="Canonical miniKanren implementation (on Chez Scheme)"
HOMEPAGE="https://github.com/miniKanren/miniKanren"
SRC_URI="https://github.com/miniKanren/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="source"
RESTRICT="strip"

RDEPEND="dev-scheme/chez:="
DEPEND="${RDEPEND}"

MINIKANREN_HOME=/usr/lib/chezscheme/${MY_PN}

src_compile() {
	local s=( $( find . -name "*.scm" -exec printf "\"%s\" " {} + ) )
	local c="(import (chezscheme)) (for-each compile-library (list ${s[@]}))"
	echo "${c}" | chezscheme --quiet --optimize-level 3 || die
}

src_install() {
	insinto ${MINIKANREN_HOME}
	doins *.so
	use source && doins *.scm

	make_wrapper ${MY_PN} "chezscheme mk.so" ${MINIKANREN_HOME}

	einstalldocs
}
