# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal toolchain-funcs flag-o-matic

DESCRIPTION="Asynchronous input/output library that uses the kernels native interface"
HOMEPAGE="https://pagure.io/libaio"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://pagure.io/libaio.git"
else
	SRC_URI="https://releases.pagure.org/${PN}/${P%_p*}.tar.gz"
	# Take Debian's patchset as upstream is dead and there's a lot of valuable
	# portability fixes in there.
	if [[ ${PV} == *_p* ]] ; then
		SRC_URI+=" mirror://debian/pool/main/liba/${PN}/${PN}_${PV/_p/-}.debian.tar.xz"
	fi
	S="${WORKDIR}"/${P%_p*}

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

src_prepare() {
	if [[ ${PV} == *_p* ]] ; then
		local i
		# Exclude patches from Debian which add time64 APIs which
		# aren't yet merged upstream.
		for i in $(sed \
				-e '/^#/d' \
				-e '/gitignore/d' \
				-e '/SONAME/d' \
				-e '/time64/d' \
				-e '/Fix-io_pgetevents-syscall-wrapper/d' "${WORKDIR}"/debian/patches/series) ; do
			PATCHES+=( "${WORKDIR}"/debian/patches/${i} )
		done
	fi

	default

	local sed_args=(
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
	if use arm ; then
		# When building for thumb, we can't allow frame pointers.
		# http://crbug.com/464517
		if $(tc-getCPP) ${CFLAGS} ${CPPFLAGS} - <<<$'#ifndef __thumb__\n#error\n#endif' >&/dev/null ; then
			append-flags -fomit-frame-pointer
		fi
	fi
}

libaio_emake() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		CFLAGS="${CFLAGS}" \
		CFLAGS_WERROR= \
		LDFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" \
		"$@"
}

multilib_src_compile() {
	libaio_emake
}

multilib_src_test() {
	mkdir -p testdir || die

	# 'make check' breaks with sandbox, 'make partcheck' works
	libaio_emake -Onone partcheck prefix="${S}/src" libdir="${S}/src"
}

multilib_src_install() {
	libaio_emake install DESTDIR="${D}"
}

multilib_src_install_all() {
	doman man/*
	dodoc ChangeLog TODO

	# This lib is a bare minimal shim on top of kernel syscalls.
	export QA_DT_NEEDED=$(find "${ED}" -type f -name 'libaio.so.*' -printf '/%P\n')
}
