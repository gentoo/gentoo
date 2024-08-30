# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ksh93/ksh"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	MY_PV=$(ver_rs 3 - 4 .)
	SRC_URI="https://github.com/ksh93/${PN}/archive/v${MY_PV}/ksh-v${MY_PV}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="The Original ATT Korn Shell"
HOMEPAGE="http://www.kornshell.com/"

LICENSE="EPL-1.0"
SLOT="0"

src_compile() {
	local extraflags=(
		"-Wno-unknown-pragmas"
		"-Wno-missing-braces"
		"-Wno-unused-result"
		"-Wno-return-type"
		"-Wno-int-to-pointer-cast"
		"-Wno-parentheses"
		"-Wno-unused"
		"-Wno-unused-but-set-variable"
		"-Wno-cpp"
		"-Wno-maybe-uninitialized"
		"-P"
	)
	append-cflags $(test-flags-CC ${extraflags[@]})
	append-cflags -fno-strict-aliasing
	filter-flags '-fdiagnostics-color=always' # https://github.com/ksh93/ksh/issues/379
	filter-lto

	export CCFLAGS="${CFLAGS}"
	tc-export AR CC LD NM

	sh bin/package make AR="${AR}" CC="${CC}" NM="${NM}" SHELL="${BROOT}"/bin/sh || die
}

src_test() {
	# test tries to catch IO error
	addwrite /proc/self/mem

	# arith.sh uses A for tests
	unset A

	sh bin/shtests --compile || die
}

src_install() {
	local myhost="$(sh bin/package host)"
	cd "arch/${myhost}" || die

	into /
	dobin bin/ksh
	dosym ksh /bin/rksh

	newman man/man1/sh.1 ksh.1
}
