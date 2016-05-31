# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs prefix eutils

DESCRIPTION="The Original Korn Shell, 1993 revision (ksh93)"
HOMEPAGE="http://www.kornshell.com/"

KSH_PV=${PV:3:4}-${PV:7:2}-${PV:9:2}

SRC_URI="https://dev.gentoo.org/~floppym/distfiles/INIT.${KSH_PV}.tgz
	https://dev.gentoo.org/~floppym/distfiles/ast-base.${KSH_PV}.tgz"

LICENSE="CPL-1.0 EPL-1.0"
SLOT="0"
KEYWORDS="alpha amd64 arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="!app-shells/pdksh"

S=${WORKDIR}

src_prepare() {
	# Bug 238906.
	sed -i -e 's,cd /tmp,cd "${TMPDIR:-/tmp}",' \
		bin/package src/cmd/INIT/package.sh || die

	epatch "${FILESDIR}"/${PN}-prefix.patch
	epatch "${FILESDIR}"/cpp.patch
	eprefixify src/cmd/ksh93/data/msg.c
}

src_compile() {
	tc-export AR CC LD NM
	export CCFLAGS="${CFLAGS}"
	sh bin/package flat only make ast-ksh SHELL=sh SHOPT_SYSRC=1 || die
}

src_install() {
	dodoc lib/package/ast-base.README
	dohtml lib/package/ast-base.html

	local myhost=$(sh bin/package host)
	into /
	dobin bin/ksh
	dosym ksh /bin/rksh
	newman man/man1/sh.1 ksh.1
}
