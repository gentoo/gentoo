# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fortran-2 flag-o-matic multilib toolchain-funcs

DESCRIPTION="Versatile, SHELX-97 compatible, multipurpose crystallographic tool"
HOMEPAGE="http://www.cryst.chem.uu.nl/platon/"
SRC_URI="http://www.cryst.chem.uu.nl/xraysoft/unix/${PN}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="free-noncomm"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

# Can't do libf2c dependent on whether <gcc-4 is selected for the build,
# so we must always require it
RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}/${PN}"

pkg_nofetch() {
	elog "If there is a digest mismatch, please file a bug"
	elog "at https://bugs.gentoo.org/ -- a version bump"
	elog "is probably required."
}

src_unpack() {
	default
	cd "${S}" || die
	gunzip platon.f.gz xdrvr.c.gz || die
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-buffer-overflow.patch
}

src_compile() {
	# easy to ICE, at least on gcc 4.3
	strip-flags

	COMMAND="$(tc-getCC) -c ${CFLAGS} xdrvr.c"
	echo ${COMMAND}
	${COMMAND} || die "Compilation of xdrvr.c failed"
	COMMAND="$(tc-getFC) -c ${FFLAGS:- -O2} -fno-second-underscore platon.f"
	echo ${COMMAND}
	${COMMAND} || die "Compilation of platon.f failed"
	COMMAND="$(tc-getFC) -o platon ${LDFLAGS} platon.o xdrvr.o -lX11 ${F2C}"
	echo ${COMMAND}
	${COMMAND} || die "Linking failed"
}

src_install() {
	dobin platon

	for bin in pluton s cifchk helena stidy; do
		dosym platon /usr/bin/${bin}
	done

	insinto /usr/$(get_libdir)/platon
	doins check.def

	echo "CHECKDEF=\"${EPREFIX}/usr/$(get_libdir)/platon/check.def\"" > "${T}"/env.d
	newenvd "${T}"/env.d 50platon

	dodoc README.*

	if use examples; then
		insinto /usr/share/${PN}
		doins -r TEST
	fi
}
