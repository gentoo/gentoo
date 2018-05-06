# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} pypy )
PYTHON_REQ_USE='bzip2(+),threads(+)'

inherit distutils-r1 git-r3

DESCRIPTION="Fork of Portage focused on cleaning up and useful features"
HOMEPAGE="https://github.com/mgorny/portage"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mgorny/portage.git"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="build +ipc +native-extensions selinux xattr kernel_linux"

DEPEND="!build? ( $(python_gen_impl_dep 'ssl(+)') )
	>=app-arch/tar-1.27
	>=sys-apps/sed-4.0.5
	sys-devel/patch"
RDEPEND="
	>=app-arch/tar-1.27
	!build? (
		>=app-admin/eselect-1.2
		app-crypt/gentoo-keys
		>=app-crypt/gnupg-2.2.4-r2[ssl(-)]
		>=app-portage/gemato-10
		app-shells/bash:0[readline]
		$(python_gen_cond_dep 'dev-python/pyblake2[${PYTHON_USEDEP}]' \
			python{2_7,3_4,3_5} pypy)
		>=dev-python/lxml-3.6.0[${PYTHON_USEDEP}]
		>=sys-apps/sed-4.0.5
	)
	elibc_FreeBSD? ( sys-freebsd/freebsd-bin )
	elibc_glibc? ( >=sys-apps/sandbox-2.2 )
	elibc_musl? ( >=sys-apps/sandbox-2.2 )
	elibc_uclibc? ( >=sys-apps/sandbox-2.2 )
	>=app-misc/pax-utils-0.1.17
	selinux? ( >=sys-libs/libselinux-2.0.94[python,${PYTHON_USEDEP}] )
	xattr? ( kernel_linux? (
		>=sys-apps/install-xattr-0.3
		$(python_gen_cond_dep 'dev-python/pyxattr[${PYTHON_USEDEP}]' \
			python2_7 pypy)
	) )
	!app-portage/repoman
	!sys-apps/portage"
PDEPEND="
	!build? (
		>=net-misc/rsync-2.6.4
	)"
# NOTE: FEATURES=installsources requires debugedit and rsync

pkg_pretend() {
	if has_version sys-apps/portage; then
		ewarn "If you are migrating from sys-apps/portage to sys-apps/portage-mgorny,"
		ewarn "please note that Portage will abort upon having to unmerge itself."
		ewarn "However, sys-apps/portage-mgorny will already be installed at this"
		ewarn "point, so you simply have to restart emerge and it will successfully"
		ewarn "clean the old package afterwards."
	fi
}

python_prepare_all() {
	distutils-r1_python_prepare_all

	if ! use ipc ; then
		einfo "Disabling ipc..."
		sed -e "s:_enable_ipc_daemon = True:_enable_ipc_daemon = False:" \
			-i pym/_emerge/AbstractEbuildProcess.py ||
			die "failed to patch AbstractEbuildProcess.py"
	fi

	if use xattr && use kernel_linux ; then
		einfo "Adding FEATURES=xattr to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} xattr"' >> cnf/make.globals \
			|| die "failed to append to make.globals"
	fi

	if [[ -n ${EPREFIX} ]] ; then
		einfo "Setting portage.const.EPREFIX ..."
		sed -e "s|^\(SANDBOX_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/bin/sandbox\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(FAKEROOT_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/bin/fakeroot\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(BASH_BINARY[[:space:]]*=[[:space:]]*\"\)\(/bin/bash\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(MOVE_BINARY[[:space:]]*=[[:space:]]*\"\)\(/bin/mv\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(PRELINK_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/sbin/prelink\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(EPREFIX[[:space:]]*=[[:space:]]*\"\).*|\\1${EPREFIX}\"|" \
			-i pym/portage/const.py ||
			die "Failed to patch portage.const.EPREFIX"

		einfo "Prefixing shebangs ..."
		while read -r -d $'\0' ; do
			local shebang=$(head -n1 "${REPLY}")
			if [[ ${shebang} == "#!"* && ! ${shebang} == "#!${EPREFIX}/"* ]] ; then
				sed -i -e "1s:.*:#!${EPREFIX}${shebang:2}:" "${REPLY}" ||
					die "sed failed"
			fi
		done < <(find . -type f -print0)

		einfo "Adjusting make.globals ..."
		sed -e "s|\(/usr/portage\)|${EPREFIX}\\1|" \
			-e "s|^\(PORTAGE_TMPDIR=\"\)\(/var/tmp\"\)|\\1${EPREFIX}\\2|" \
			-i cnf/make.globals || die "sed failed"

		einfo "Adjusting repos.conf ..."
		sed -e "s|^\(location = \)\(/usr/portage\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(sync-openpgp-key-path = \)\(.*\)|\\1${EPREFIX}\\2|" \
			-i cnf/repos.conf || die "sed failed"
		if prefix-guest ; then
			sed -e "s|^\(main-repo = \).*|\\1gentoo_prefix|" \
				-e "s|^\\[gentoo\\]|[gentoo_prefix]|" \
				-e "s|^\(sync-uri = \).*|\\1rsync://rsync.prefix.bitzolder.nl/gentoo-portage-prefix|" \
				-i cnf/repos.conf || die "sed failed"
		fi

		einfo "Adding FEATURES=force-prefix to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} force-prefix"' >> cnf/make.globals \
			|| die "failed to append to make.globals"
	fi

	cd "${S}/cnf" || die
	if [[ -f make.conf.example.${ARCH}.diff ]]; then
		patch make.conf.example "make.conf.example.${ARCH}.diff" ||
			die "Failed to patch make.conf.example"
	else
		eerror ""
		eerror "Portage does not have an arch-specific configuration for this arch."
		eerror "Please notify the arch maintainer about this issue. Using generic."
		eerror ""
	fi
}

python_configure_all() {
	cat >> setup.cfg <<-EOF || die
		[build_ext]
		portage-ext-modules=$(usex native-extensions true false)
	EOF
}

python_test() {
	esetup.py test
}

python_install() {
	distutils-r1_python_install \
		--system-prefix="${EPREFIX}/usr" \
		--bindir="$(python_get_scriptdir)" \
		--portage-bindir="${EPREFIX}/usr/lib/portage/${EPYTHON}" \
		--sysconfdir="${EPREFIX}/etc" \
		"${@}"

	keepdir /var/log/portage/elog
}

pkg_preinst() {
	# This is allowed to fail if the user/group are invalid for prefix users.
	if chown portage:portage "${ED%/}"/var/log/portage{,/elog} 2>/dev/null ; then
		chmod g+s,ug+rwx "${ED%/}"/var/log/portage{,/elog}
	fi
}
