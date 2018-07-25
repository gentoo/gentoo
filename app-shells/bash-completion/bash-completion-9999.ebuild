# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BASHCOMP_P=bashcomp-2.0.2
EGIT_REPO_URI="https://github.com/scop/bash-completion"
inherit autotools git-r3 versionator

DESCRIPTION="Programmable Completion for bash"
HOMEPAGE="https://github.com/scop/bash-completion"
SRC_URI="https://bitbucket.org/mgorny/bashcomp2/downloads/${BASHCOMP_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="test"

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

	# Installed by sys-apps/util-linux-2.28 (and now deprecated)
	_mount _umount _mount.linux _umount.linux

	# Deprecated in favor of sys-apps/util-linux-2.31
	_rfkill
)

src_unpack() {
	git-r3_src_unpack
	default
}

src_prepare() {
	eapply "${WORKDIR}/${BASHCOMP_P}/${PN}"-2.1_p*.patch
	eapply_user

	eautoreconf
}

src_test() {
	# Tests need an interactive shell, #477066
	# idea stolen from:
	# http://pkgs.fedoraproject.org/cgit/rpms/bash-completion.git/tree/bash-completion.spec

	# real-time output of the log ;-)
	touch "${T}/dtach-test.log" || die
	tail -f "${T}/dtach-test.log" &
	local tail_pid=${!}

	# override the default expect timeout and buffer size to avoid tests
	# failing randomly due to cold cache, busy system or just more output
	# than upstream anticipated (they run tests on pristine docker
	# installs of binary distros)
	nonfatal dtach -N "${T}/dtach.sock" \
		bash -c 'emake check RUNTESTFLAGS="OPT_TIMEOUT=300 OPT_BUFFER_SIZE=1000000" \
			&> "${T}"/dtach-test.log; echo ${?} > "${T}"/dtach-test.out'

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
		rm "${ED}"/usr/share/bash-completion/completions/${file} ||
			die "stripping ${file} failed"
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
