# Copyright 2018-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit edo ninja-utils python-any-r1 toolchain-funcs

DESCRIPTION="GN is a meta-build system that generates build files for Ninja"
HOMEPAGE="https://gn.googlesource.com/"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gn.googlesource.com/gn"
else
	# The version number is derived from `git describe HEAD --abbrev=12`
	SRC_URI="https://deps.gentoo.zip/dev-build/gn/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="BSD"
SLOT="0"

BDEPEND="
	${PYTHON_DEPS}
	app-alternatives/ninja
"

PATCHES=(
	"${FILESDIR}"/gn-gen-r5.patch
)

pkg_setup() {
	:
}

src_configure() {
	python_setup
	tc-export AR CC CXX
	if use elibc_musl ; then # bug 906362
		export CC="${CC} -D_LARGEFILE64_SOURCE"
		export CXX="${CXX} -D_LARGEFILE64_SOURCE"
	fi
	unset CFLAGS
	set -- ${EPYTHON} build/gen.py --no-last-commit-position --no-strip --no-static-libstdc++ --allow-warnings
	edo "$@"
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

	insinto /usr/share/vim/vimfiles
	doins -r misc/vim/{autoload,ftdetect,ftplugin,syntax}
}
