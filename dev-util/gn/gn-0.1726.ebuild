# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit ninja-utils python-any-r1 toolchain-funcs

DESCRIPTION="GN is a meta-build system that generates build files for Ninja"
HOMEPAGE="https://gn.googlesource.com/"
SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"
IUSE="vim-syntax"

BDEPEND="
	${PYTHON_DEPS}
	dev-util/ninja
"

PATCHES=(
	"${FILESDIR}"/gn-gen-r4.patch
)

pkg_setup() {
	:
}

src_configure() {
	python_setup
	tc-export AR CC CXX
	unset CFLAGS
	set -- ${EPYTHON} build/gen.py --no-last-commit-position --no-strip --no-static-libstdc++
	echo "$@" >&2
	"$@" || die
	cat >out/last_commit_position.h <<-EOF || die
	#ifndef OUT_LAST_COMMIT_POSITION_H_
	#define OUT_LAST_COMMIT_POSITION_H_
	#define LAST_COMMIT_POSITION_NUM ${PV##0.}
	#define LAST_COMMIT_POSITION "${PV}"
	#endif  // OUT_LAST_COMMIT_POSITION_H_
	EOF
}

src_compile() {
	eninja -C out gn
}

src_test() {
	eninja -C out gn_unittests
	out/gn_unittests || die
}

src_install() {
	dobin out/gn
	einstalldocs

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles
		doins -r misc/vim/{autoload,ftdetect,ftplugin,syntax}
	fi
}
