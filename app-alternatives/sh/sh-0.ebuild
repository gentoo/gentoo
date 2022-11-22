# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="/bin/sh (POSIX shell) symlink"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base/Alternatives"
SRC_URI=""
S=${WORKDIR}

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+bash dash ksh lksh mksh"
REQUIRED_USE="^^ ( bash dash ksh lksh mksh )"

RDEPEND="
	bash? ( app-shells/bash )
	dash? ( app-shells/dash )
	ksh? ( app-shells/ksh )
	lksh? ( app-shells/mksh[lksh] )
	mksh? ( app-shells/mksh )
	!!app-eselect/eselect-sh
"

src_install() {
	if use bash; then
		dosym bash /bin/sh
	elif use dash; then
		dosym dash /bin/sh
	elif use ksh; then
		dosym ksh /bin/sh
	elif use lksh; then
		dosym lksh /bin/sh
	elif use mksh; then
		dosym mksh /bin/sh
	else
		die "Invalid USE flag combination (broken REQUIRED_USE?)"
	fi
}

pkg_postrm() {
	# make sure we don't leave the user without /bin/sh, since it's not
	# been owned by any other package
	if [[ ! -h ${EROOT}/bin/sh ]]; then
		ln -s bash "${EROOT}/bin/sh" || die
	fi
}
