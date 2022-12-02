# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	bash:app-shells/bash
	dash:app-shells/dash
	ksh:app-shells/ksh
	"lksh:app-shells/mksh[lksh]"
	mksh:app-shells/mksh
)

inherit app-alternatives

DESCRIPTION="/bin/sh (POSIX shell) symlink"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	!!app-eselect/eselect-sh
"

src_install() {
	dosym "$(get_alternative)" /bin/sh || die
}

pkg_postrm() {
	# make sure we don't leave the user without /bin/sh, since it's not
	# been owned by any other package
	if [[ ! -h ${EROOT}/bin/sh ]]; then
		ln -s bash "${EROOT}/bin/sh" || die
	fi
}
