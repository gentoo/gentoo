# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	bash:app-shells/bash
	busybox:sys-apps/busybox
	dash:app-shells/dash
	ksh:app-shells/ksh
	"lksh:app-shells/mksh[lksh]"
	mksh:app-shells/mksh
)

inherit app-alternatives

DESCRIPTION="/bin/sh (POSIX shell) symlink"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	!app-eselect/eselect-sh
"

pkg_setup() {
	if [[ -z ${ROOT} ]] && use busybox ; then
		# Needed to avoid busybox preferring internal applets over PATH lookups.
		# https://web.archive.org/web/20221206223848/https://busybox.net/FAQ.html#standalone_shell.
		if busybox bbconfig | grep -q "CONFIG_FEATURE_SH_STANDALONE=y" ; then
			ewarn "busybox is configured with CONFIG_FEATURE_SH_STANDALONE=y!"
			ewarn "This is not a safe configuration for busybox as /bin/sh."
			ewarn "Please use savedconfig to disable CONFIG_FEATURE_SH_STANDALONE on busybox."
			die "Aborting due to unsafe Busybox configuration (CONFIG_FEATURE_SH_STANDALONE=y)!"
		fi
	fi
}

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
