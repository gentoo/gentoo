# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs prefix eutils

DESCRIPTION="The Original Korn Shell, 1993 revision (ksh93)"
HOMEPAGE="http://www.kornshell.com/"

COMMIT="c506cb548d9b4bcebef92c86e948657728760e15"
SRC_URI="https://github.com/att/ast/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="CPL-1.0 EPL-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="!app-shells/pdksh"

S="${WORKDIR}/ast-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/ksh-prefix.patch
	"${FILESDIR}"/cpp.patch
)

src_prepare() {
	default

	# Bug 238906.
	sed -i -e 's,cd /tmp,cd "${TMPDIR:-/tmp}",' \
		bin/package src/cmd/INIT/package.sh || die

	eprefixify src/cmd/ksh93/data/msg.c
}

src_compile() {
	tc-export AR CC LD NM
	export CCFLAGS="${CFLAGS}"
	sh bin/package flat only make ast-ksh SHELL=sh SHOPT_SYSRC=1 || die
	# The build system doesn't exit properly
	[[ -e bin/ksh ]] || die
}

src_install() {
	into /
	dobin bin/ksh
	dosym ksh /bin/rksh
	newman man/man1/sh.1 ksh.1
}
