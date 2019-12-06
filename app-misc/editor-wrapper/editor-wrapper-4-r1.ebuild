# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Wrapper scripts that will execute EDITOR or PAGER"
# There is no upstream, everything is in FILESDIR.
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

S="${WORKDIR}"

src_prepare() {
	sed -e 's/@VAR@/EDITOR/g' "${FILESDIR}/${P}.sh" >editor || die
	sed -e 's/@VAR@/PAGER/g'  "${FILESDIR}/${P}.sh" >pager  || die
	if use prefix ; then
		sed -i \
			-e "s:#!/bin/sh:#!/usr/bin/env sh:" \
			-e "s: /etc/profile: \"${EPREFIX}/etc/profile\":" \
			editor pager || die
	fi
	eapply_user
}

src_install() {
	exeinto /usr/libexec
	doexe editor pager
}
