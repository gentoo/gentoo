# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Manifest generation and verification tool written in C"
HOMEPAGE="https://prefix.gentoo.org/"
GITHASH="7fc3cf2b4baddc8b98c994b8ee024330d8f29956"
SRC_URI="https://gitweb.gentoo.org/repo/proj/prefix.git/plain/scripts/rsync-generation/hashgen.c?id=${GITHASH} -> ${P}.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x64-macos ~sparc-solaris ~x64-solaris"
IUSE="+openmp"

DEPEND="
	openmp? (
		|| ( >=sys-devel/gcc-4.2:*[openmp] sys-devel/clang-runtime:*[openmp] )
	)
	app-crypt/libb2
	dev-libs/openssl:0=
	sys-libs/zlib
	app-crypt/gpgme
"
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir "${S}" || die
	cp "${DISTDIR}"/${P}.c "${S}"/${PN}.c || die
}

src_compile() {
	v() {
		echo "$@"
		"$@"
	}

	local openmp=
	use openmp && tc-has-openmp && openmp=-fopenmp

	[[ ${CHOST} == sparc-*-solaris2* || ${CHOST} == i?86-*-solaris2* ]] \
		&& append-flags -D_FILE_OFFSET_BITS=64

	v $(tc-getCC) -o hashgen ${openmp} ${CFLAGS} \
		$(pkg-config openssl --libs) \
		$(gpgme-config --libs) \
		-lb2 -lz ${LDFLAGS} ${PN}.c || die
}

src_install() {
	dobin hashgen
	cd "${ED}"/usr/bin || die
	ln -s hashgen hashverify || die
}
