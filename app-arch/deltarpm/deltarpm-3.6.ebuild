# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit toolchain-funcs python-single-r1

DESCRIPTION="tools to create and apply deltarpms"
HOMEPAGE="https://github.com/rpm-software-management/deltarpm"
SRC_URI="http://pkgs.fedoraproject.org/repo/pkgs/${PN}/${P}.tar.bz2/2cc2690bd1088cfc3238c25e59aaaec1/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python system-zlib"

RDEPEND="sys-libs/zlib
	app-arch/xz-utils
	app-arch/bzip2
	<app-arch/rpm-5
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	python-single-r1_pkg_setup

	MAKE_EXTRA_FLAGS=(
		-j1
		prefix=/usr
		mandir=/usr/share/man
		PYTHONS=$(use python && echo python)
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
		CC="$(tc-getCC)"
	)
	use system-zlib && MAKE_EXTRA_FLAGS+=(
		zlibbundled=
		zlibcppflags=
		zlibldflags=-lz
	)
}

src_compile() {
	emake "${MAKE_EXTRA_FLAGS[@]}" all $(use python && echo python)
}

src_install() {
	emake "${MAKE_EXTRA_FLAGS[@]}" DESTDIR="${ED}" install
	python_optimize
}
