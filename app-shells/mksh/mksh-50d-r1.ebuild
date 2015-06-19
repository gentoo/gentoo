# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/mksh/mksh-50d-r1.ebuild,v 1.1 2015/01/18 01:44:25 patrick Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="MirBSD KSH Shell"
HOMEPAGE="http://mirbsd.de/mksh"
SRC_URI="http://www.mirbsd.org/MirOS/dist/mir/mksh/${PN}-R${PV}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="static"
DEPEND="static? ( dev-libs/klibc )"
RDEPEND=""
S="${WORKDIR}/${PN}"

src_compile() {
	tc-export CC
	# we want to build static with klibc
	if use static ; then
		unset CC
		export CC="/usr/bin/klcc"
		export LDSTATIC="-static"
	fi
	export CPPFLAGS="${CPPFLAGS} -DMKSH_DEFAULT_PROFILEDIR=\\\"${EPREFIX}/etc\\\""
	# we can't assume lto existing/enabled, so we add a fallback
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
