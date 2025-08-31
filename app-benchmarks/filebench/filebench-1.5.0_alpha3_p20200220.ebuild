# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

COMMIT_HASH="22620e602cbbebad90c0bd041896ebccf70dbf5f"
DESCRIPTION="Filebench - A Model Based File System Workload Generator"
HOMEPAGE="https://github.com/filebench/filebench"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

DEPEND="
	app-alternatives/lex
	app-alternatives/yacc
"

PATCHES=(
	# https://github.com/filebench/filebench/pull/143
	"${FILESDIR}"/${PN}-1.5.0_alpha3_add_suppress_asr.patch
	# https://github.com/filebench/filebench/pull/160 #906004
	"${FILESDIR}"/${PN}-1.5.0_alpha3_fix_implicit_syscall.patch
	# selected commits from https://github.com/filebench/filebench/pull/116 #943905
	"${FILESDIR}"/${PN}-1.5.0_alpha3_fix_gcc15.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
