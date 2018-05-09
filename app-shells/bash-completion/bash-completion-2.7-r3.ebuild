# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BASHCOMP_P=bashcomp-2.0.2
inherit versionator

DESCRIPTION="Programmable Completion for bash"
HOMEPAGE="https://github.com/scop/bash-completion"
SRC_URI="https://github.com/scop/bash-completion/releases/download/${PV}/${P}.tar.xz
	https://bitbucket.org/mgorny/bashcomp2/downloads/${BASHCOMP_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ~ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris"
IUSE="test"
# Multiple test failures, need to investigate the exact problem
RESTRICT="test"

# completion collision with net-fs/mc
RDEPEND=">=app-shells/bash-4.3_p30-r1
	sys-apps/miscfiles
	!app-eselect/eselect-bashcomp
	!!net-fs/mc"
DEPEND="app-arch/xz-utils
	test? (
		${RDEPEND}
		app-misc/dtach
		dev-util/dejagnu
		dev-tcltk/tcllib
	)"
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

	# Installed by sys-apps/util-linux-2.28
	mount umount mount.linux umount.linux

	# Installed by sys-apps/util-linux-2.31
	rfkill
)

src_prepare() {
	eapply "${WORKDIR}/${BASHCOMP_P}/${PN}"-2.1_p*.patch
	# Bug 543100, update bug 601194
	eapply "${FILESDIR}/${PN}-2.1-escape-characters-r1.patch"
	eapply_user

	# Remove implicit completions for vim.
	# https://bugs.gentoo.org/649986
	sed -i -e 's/vi vim gvim rvim view rview rgvim rgview gview//' \
		bash_completion || die
	rm test/completion/vi.exp || die
}

src_test() {
	# Tests need an interactive shell, #477066
	# idea stolen from:
	# http://pkgs.fedoraproject.org/cgit/rpms/bash-completion.git/tree/bash-completion.spec

	# real-time output of the log ;-)
	touch "${T}/dtach-test.log" || die
	tail -f "${T}/dtach-test.log" &
	local tail_pid=${!}

	nonfatal dtach -N "${T}/dtach.sock" \
		bash -c 'emake check &> "${T}"/dtach-test.log; echo ${?} > "${T}"/dtach-test.out'

	kill "${tail_pid}"
	[[ -f ${T}/dtach-test.out ]] || die "Unable to run tests"
	[[ $(<"${T}"/dtach-test.out) == 0 ]] || die "Tests failed"
}

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

	dodoc AUTHORS CHANGES CONTRIBUTING.md README.md

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
