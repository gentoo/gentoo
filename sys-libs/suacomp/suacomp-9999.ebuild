# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs git-r3

DESCRIPTION="library wrapping the interix lib-c to make it less buggy"
HOMEPAGE="http://suacomp.sf.net"
EGIT_REPO_URI="https://git.code.sf.net/p/suacomp/git"

LICENSE="BEER-WARE"
SLOT="0"
IUSE="debug"

DEPEND=""
RDEPEND=""

get_opts() {
	local shlibc=
	local stlibc=

	local dir
	for dir in /usr/lib /usr/lib/x86; do
		[[ -f ${dir}/libc.a ]] && stlibc=${dir}/libc.a

		local name
		for name in libc.so.5.2 libc.so.3.5; do
			[[ -f ${dir}/${name} ]] && { shlibc=${dir}/${name}; break; }
		done

		[[ -f ${shlibc} && -f ${stlibc} ]] && break
	done

	echo "SHARED_LIBC=${shlibc} STATIC_LIBC=${stlibc}"
}

src_configure() {
	if use debug; then
		append-flags -D_DEBUG -D_DEBUG_TRACE
	fi
}

src_compile() {
	emake all CC=$(tc-getCC) $(get_opts) CFLAGS="${CFLAGS}"
}

src_test() {
	local v=

	use debug && v="TEST_VERBOSE=1"
	use debug && export SUACOMP_DEBUG_OUT=stderr

	emake check $(get_opts) ${v}
}

src_install() {
	emake install PREFIX="${EPREFIX}/usr" DESTDIR="${D}" $(get_opts) \
		CFLAGS="${CFLAGS}"
}
