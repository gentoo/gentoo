# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit autotools git-r3 python-any-r1 user-info

DESCRIPTION="Programmable Completion for bash"
HOMEPAGE="https://github.com/scop/bash-completion"
EGIT_REPO_URI="https://github.com/scop/bash-completion"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="+eselect test"
RESTRICT="!test? ( test )"

# completion collision with net-fs/mc
RDEPEND=">=app-shells/bash-4.3_p30-r1:0
	sys-apps/miscfiles
	!!net-fs/mc"
DEPEND="
	test? (
		${RDEPEND}
		$(python_gen_any_dep '
			dev-python/pexpect[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)"
PDEPEND=">=app-shells/gentoo-bashcomp-20140911"

strip_completions() {
	# Remove unwanted completions.
	local strip_completions=(
		# Slackware package stuff, quite generic names cause collisions
		# (e.g. with sys-apps/pacman)
		explodepkg installpkg makepkg pkgtool removepkg upgradepkg

		# Debian/Red Hat network stuff
		ifdown ifup ifquery ifstatus

		# Installed in app-editors/vim-core
		xxd

		# Now-dead symlinks to deprecated completions
		hd ncal
	)
	if [[ ${ARCH} != *-fbsd && ${ARCH} != *-freebsd ]]; then
		strip_completions+=(
			freebsd-update kldload kldunload portinstall portsnap
			pkg_deinstall pkg_delete pkg_info
		)
	fi

	local file
	for file in "${strip_completions[@]}"; do
		rm "${ED}"/usr/share/bash-completion/completions/${file} ||
			die "stripping ${file} failed"
	done

	# remove deprecated completions (moved to other packages)
	rm "${ED}"/usr/share/bash-completion/completions/_* || die
}

python_check_deps() {
	has_version "dev-python/pexpect[${PYTHON_USEDEP}]" &&
	has_version "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	use eselect && git-r3_fetch https://github.com/mgorny/bashcomp2
	git-r3_fetch

	use eselect && git-r3_checkout https://github.com/mgorny/bashcomp2 \
		"${WORKDIR}"/bashcomp2
	git-r3_checkout
}

src_prepare() {
	if use eselect; then
		# generate and apply patch
		emake -C "${WORKDIR}"/bashcomp2 bash-completion-blacklist-support.patch
		eapply "${WORKDIR}"/bashcomp2/bash-completion-blacklist-support.patch
	fi

	# redhat-specific, we strip these completions
	rm test/t/test_if{down,up}.py || die
	# not available for icedtea
	rm test/t/test_javaws.py || die

	eapply_user
	eautoreconf
}

src_test() {
	# portage's HOME override breaks tests
	emake check HOME="$(egethome "${UID}")" PYTESTFLAGS="-vv" NETWORK=none
}

src_install() {
	# work-around race conditions, bug #526996
	mkdir -p "${ED}"/usr/share/bash-completion/{completions,helpers} || die

	emake DESTDIR="${D}" profiledir="${EPREFIX}"/etc/bash/bashrc.d install

	strip_completions

	dodoc AUTHORS CHANGES CONTRIBUTING.md README.md

	# install the eselect module
	use eselect &&
		emake -C "${WORKDIR}"/bashcomp2 DESTDIR="${D}" \
			PREFIX="${EPREFIX}/usr" install
}

pkg_postinst() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "${v}" -lt 2.1-r90; then
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
