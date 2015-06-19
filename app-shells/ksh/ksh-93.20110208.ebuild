# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/ksh/ksh-93.20110208.ebuild,v 1.7 2012/04/01 17:17:28 armin76 Exp $

EAPI=4

inherit toolchain-funcs versionator

DESCRIPTION="The Original Korn Shell, 1993 revision (ksh93)"
HOMEPAGE="http://www.kornshell.com/"

INIT_RELEASE="2012-01-01"
ksh_release() {
	local v="$(get_version_component_range 2)"
	echo "${v:0:4}-${v:4:2}-${v:6:2}"
}

SRC_URI="http://dev.gentoo.org/~floppym/distfiles/INIT.${INIT_RELEASE}.tgz
	http://dev.gentoo.org/~floppym/distfiles/ast-base.$(ksh_release).tgz"

LICENSE="CPL-1.0 EPL-1.0"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ~ppc64 s390 sparc x86"
IUSE=""

RDEPEND="!app-shells/pdksh"

S=${WORKDIR}

src_prepare() {
	# Bug 238906.
	sed -i -e 's,cd /tmp,cd "${TMPDIR:-/tmp}",' \
		bin/package src/cmd/INIT/package.sh || die
}

src_compile() {
	tc-export AR CC LD NM
	export CCFLAGS="${CFLAGS}"
	sh bin/package only make ast-ksh SHELL=/bin/sh SHOPT_SYSRC=1 || die
}

src_install() {
	dodoc lib/package/ast-base.README
	dohtml lib/package/ast-base.html

	local myhost="$(sh bin/package host)"
	cd "arch/${myhost}" || die
	into /
	dobin bin/ksh
	dosym ksh /bin/rksh
	newman man/man1/sh.1 ksh.1
}
