# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal toolchain-funcs flag-o-matic

DESCRIPTION="Asynchronous input/output library that uses the kernels native interface"
HOMEPAGE="https://pagure.io/libaio"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://pagure.io/libaio.git"
else
	SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.112-cppflags.patch
	"${FILESDIR}"/${PN}-0.3.113-respect-LDFLAGS.patch
	"${FILESDIR}"/${PN}-0.3.113-32-bit-tests.patch
)

src_prepare() {
	default

	local sed_args=(
		-e "/^prefix=/s:/usr:${EPREFIX}/usr:"
		-e '/^libdir=/s:lib$:$(ABI_LIBDIR):'
		-e 's:-Werror ::'
	)
	if ! use static-libs; then
		sed_args+=( -e '/\tinstall .*\/libaio.a/d' )
		# Tests require the static library to be built.
		use test || sed_args+=( -e '/^all_targets +=/s/ libaio.a//' )
	fi
	sed -i "${sed_args[@]}" src/Makefile harness/Makefile Makefile || die

	multilib_copy_sources
}

multilib_src_configure() {
	# Upstream aren't interested in fixing: bug #855698
	filter-lto

	if use arm ; then
		# When building for thumb, we can't allow frame pointers.
		# http://crbug.com/464517
		if $(tc-getCPP) ${CFLAGS} ${CPPFLAGS} - <<<$'#ifndef __thumb__\n#error\n#endif' >&/dev/null ; then
			append-flags -fomit-frame-pointer
		fi
	fi
}

_emake() {
	CC="$(tc-getCC)" \
	AR="$(tc-getAR)" \
	RANLIB="$(tc-getRANLIB)" \
	ABI_LIBDIR="$(get_libdir)" \
	CFLAGS_WERROR= \
	emake "$@"
}

multilib_src_compile() {
	_emake
}

multilib_src_test() {
	mkdir -p testdir || die

	# 'make check' breaks with sandbox, 'make partcheck' works
	_emake partcheck prefix="${S}/src" libdir="${S}/src"
}

multilib_src_install() {
	_emake install DESTDIR="${D}"
}

multilib_src_install_all() {
	doman man/*
	dodoc ChangeLog TODO

	# This lib is a bare minimal shim on top of kernel syscalls.
	export QA_DT_NEEDED=$(find "${ED}" -type f -name 'libaio.so.*' -printf '/%P\n')
}
