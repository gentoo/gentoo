# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

if [[ $PV = 9999 ]]; then
	inherit cvs
	ECVS_SERVER="anoncvs.mirbsd.org:/cvs"
	ECVS_MODULE="mksh"
	ECVS_USER="_anoncvs"
	ECVS_AUTH="ext"
	KEYWORDS=""
	DEPEND="static? ( dev-libs/klibc )"
else
	inherit unpacker
	DEPEND="app-arch/cpio
		static? ( dev-libs/klibc )"
	SRC_URI="http://www.mirbsd.org/MirOS/dist/mir/mksh/${PN}-R${PV}.cpio.gz"
	KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux"
fi

DESCRIPTION="MirBSD Korn Shell"
HOMEPAGE="http://mirbsd.de/mksh"
LICENSE="BSD"
SLOT="0"
IUSE="static"
RDEPEND=""
S="${WORKDIR}/${PN}"

src_compile() {
	tc-export CC
	# we want to build static with klibc
	if use static; then unset CC; export CC="/usr/bin/klcc"; export LDSTATIC="-static"; fi
	export CPPFLAGS="${CPPFLAGS} -DMKSH_DEFAULT_PROFILEDIR=\\\"${EPREFIX}/etc\\\""
	sh Build.sh -r -c lto || sh Rebuild.sh || die
}

src_install() {
	exeinto /bin
	doexe mksh
	doman mksh.1
	dodoc dot.mkshrc
}

src_test() {
	./test.sh || die
}

pkg_postinst() {
	ebegin "Updating /etc/shells"
	( grep -v "^/bin/mksh$" "${ROOT}"etc/shells; echo "/bin/mksh" ) > "${T}"/shells
	mv -f "${T}"/shells "${ROOT}"etc/shells
	eend $?
}
