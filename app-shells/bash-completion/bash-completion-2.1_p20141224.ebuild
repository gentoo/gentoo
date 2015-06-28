# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/bash-completion/bash-completion-2.1_p20141224.ebuild,v 1.6 2015/06/28 10:02:49 zlogene Exp $

EAPI=5

BASHCOMP_P=bashcomp-2.0.1
inherit versionator

DESCRIPTION="Programmable Completion for bash"
HOMEPAGE="http://bash-completion.alioth.debian.org/"
SRC_URI="http://dev.gentoo.org/~mgorny/dist/${P}.tar.xz
	http://dev.gentoo.org/~mgorny/dist/${BASHCOMP_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris"
IUSE=""

RDEPEND=">=app-shells/bash-4.3_p30-r1
	sys-apps/miscfiles
	!app-eselect/eselect-bashcomp"
DEPEND="app-arch/xz-utils"
PDEPEND=">=app-shells/gentoo-bashcomp-20140911"

# Remove unwanted completions.
STRIP_COMPLETIONS=(
	# Slackware package stuff, quite generic names cause collisions
	# (e.g. with sys-apps/pacman)
	explodepkg installpkg makepkg pkgtool removepkg upgradepkg

	# Debian/Red Hat network stuff
	ifdown ifup ifstatus

	# Installed in app-editors/vim-core
	xxd

	# Now-dead symlinks to deprecated completions
	hd ncal
)

src_prepare() {
	epatch "${WORKDIR}/${BASHCOMP_P}/${P}"-*.patch
}

src_test() { :; } # Skip testsuite because of interactive shell wrt #477066

src_install() {
	# work-around race conditions, bug #526996
	mkdir -p "${ED}"/usr/share/bash-completion/{completions,helpers} || die

	emake DESTDIR="${D}" profiledir="${EPREFIX}"/etc/bash/bashrc.d install

	local file
	for file in "${STRIP_COMPLETIONS[@]}"; do
		rm "${ED}"/usr/share/bash-completion/completions/${file} || die
	done
	# remove deprecated completions (moved to other packages)
	rm "${ED}"/usr/share/bash-completion/completions/_* || die

	dodoc AUTHORS CHANGES README

	# install the eselect module
	insinto /usr/share/eselect/modules
	doins "${WORKDIR}/${BASHCOMP_P}/bashcomp.eselect"
	doman "${WORKDIR}/${BASHCOMP_P}/bashcomp.eselect.5"
}

pkg_postinst() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 2.1-r90 ${v}; then
			ewarn "For bash-completion autoloader to work, all completions need to"
			ewarn "be installed in /usr/share/bash-completion/completions. You may"
			ewarn "need to rebuild packages that installed completions in the old"
			ewarn "location. You can do this using:"
			ewarn
			ewarn "$ find ${EPREFIX}/usr/share/bash-completion -maxdepth 1 -type f '!' -name 'bash_completion' -exec emerge -1v {} +"
			ewarn
			ewarn "After the rebuild, you should remove the old setup symlinks:"
			ewarn
			ewarn "$ find ${EPREFIX}/etc/bash_completion.d -type l -delete"
		fi
	done

	if has_version 'app-shells/zsh'; then
		elog
		elog "If you are interested in using the provided bash completion functions with"
		elog "zsh, valuable tips on the effective use of bashcompinit are available:"
		elog "  http://www.zsh.org/mla/workers/2003/msg00046.html"
		elog
	fi
}
