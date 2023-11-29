# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_EXT=1
PYTHON_COMPAT=( pypy3 python3_{10..12} )
PYTHON_REQ_USE='bzip2(+),threads(+)'
SETUPTOOLS_USE_DISTUTILS=local
TMPFILES_OPTIONAL=1

inherit distutils-r1 linux-info toolchain-funcs tmpfiles prefix

DESCRIPTION="The package management and distribution system for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="
		https://anongit.gentoo.org/git/proj/portage.git
		https://github.com/gentoo/portage.git
	"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/portage.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="apidoc build doc gentoo-dev +ipc +native-extensions +rsync-verify selinux test xattr"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-vcs/git )
"
DEPEND="
	>=app-arch/tar-1.27
	dev-lang/python-exec:2
	>=sys-apps/sed-4.0.5 sys-devel/patch
	!build? ( $(python_gen_impl_dep 'ssl(+)') )
	apidoc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-epytext[${PYTHON_USEDEP}]
	)
	doc? (
		app-text/xmlto
		~app-text/docbook-xml-dtd-4.4
	)
"
# Require sandbox-2.2 for bug #288863.
# For whirlpool hash, require python[ssl] (bug #425046).
# For compgen, require bash[readline] (bug #445576).
# app-portage/gemato goes without PYTHON_USEDEP since we're calling
# the executable.
RDEPEND="
	acct-user/portage
	app-arch/zstd
	>=app-arch/tar-1.27
	dev-lang/python-exec:2
	>=sys-apps/baselayout-2.9
	>=sys-apps/findutils-4.9
	!build? (
		>=app-admin/eselect-1.2
		>=app-shells/bash-5.0:0[readline]
		>=sys-apps/sed-4.0.5
		>=sec-keys/openpgp-keys-gentoo-release-20230329
		rsync-verify? (
			>=app-portage/gemato-14.5[${PYTHON_USEDEP}]
			>=app-crypt/gnupg-2.2.4-r2[ssl(-)]
		)
	)
	elibc_glibc? ( >=sys-apps/sandbox-2.2 )
	elibc_musl? ( >=sys-apps/sandbox-2.2 )
	kernel_linux? ( sys-apps/util-linux )
	>=app-misc/pax-utils-0.1.17
	selinux? ( >=sys-libs/libselinux-2.0.94[python,${PYTHON_USEDEP}] )
	xattr? ( kernel_linux? (
		>=sys-apps/install-xattr-0.3
	) )
	!<app-admin/logrotate-3.8.0
	!<app-portage/gentoolkit-0.4.6
	!<app-portage/repoman-2.3.10
	!~app-portage/repoman-3.0.0
"
# coreutils-6.4 rdep is for date format in emerge-webrsync #164532
# NOTE: FEATURES=installsources requires debugedit and rsync
PDEPEND="
	!build? (
		>=net-misc/rsync-2.6.4
		>=sys-apps/coreutils-6.4
		>=sys-apps/file-5.44-r3
	)
"

PATCHES=(
	# message patch used in 3.0.48.1 and 3.0.49 (bug 909853)
	"${FILESDIR}/depgraph.py-fix-no-ebuilds-binpkgs-message.patch"
	# backport from master to help Prefix bootstraps (bug #640658)
	"${FILESDIR}/portage-3.0.49-prefixify-init-script-shebangs.patch"
)

distutils_enable_tests pytest

pkg_pretend() {
	local CONFIG_CHECK="~IPC_NS ~PID_NS ~NET_NS ~UTS_NS"

	if use native-extensions && tc-is-cross-compiler; then
		einfo "Disabling USE=native-extensions for cross-compilation (bug #612158)"
	fi

	check_extra_config
}

python_prepare_all() {
	distutils-r1_python_prepare_all

	if [[ ${PV} != 9999 ]] ; then
		sed -e "s:^VERSION = \"HEAD\"$:VERSION = \"${PV}\":" -i lib/portage/__init__.py || die
	fi

	if use gentoo-dev; then
		einfo "Disabling --dynamic-deps by default for gentoo-dev..."
		sed -e 's:\("--dynamic-deps", \)\("y"\):\1"n":' \
			-i lib/_emerge/create_depgraph_params.py || \
			die "failed to patch create_depgraph_params.py"

		einfo "Enabling additional FEATURES for gentoo-dev..."
		echo 'FEATURES="${FEATURES} ipc-sandbox network-sandbox strict-keepdir warn-on-large-env"' \
			>> cnf/make.globals || die
	fi

	if use native-extensions && ! tc-is-cross-compiler; then
		printf "[build_ext]\nportage_ext_modules=true\n" >> \
			setup.cfg || die
	fi

	if ! use ipc ; then
		einfo "Disabling ipc..."
		sed -e "s:_enable_ipc_daemon = True:_enable_ipc_daemon = False:" \
			-i lib/_emerge/AbstractEbuildProcess.py || \
			die "failed to patch AbstractEbuildProcess.py"
	fi

	if use xattr && use kernel_linux ; then
		einfo "Adding FEATURES=xattr to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} xattr"' >> cnf/make.globals \
			|| die "failed to append to make.globals"
	fi

	if use build || ! use rsync-verify; then
		sed -e '/^sync-rsync-verify-metamanifest/s|yes|no|' \
			-e '/^sync-webrsync-verify-signature/s|yes|no|' \
			-i cnf/repos.conf || die "sed failed"
	fi

	if [[ -n ${EPREFIX} ]] ; then
		einfo "Setting portage.const.EPREFIX ..."
		hprefixify -e "s|^(EPREFIX[[:space:]]*=[[:space:]]*\").*|\1${EPREFIX}\"|" \
			-w "/_BINARY/" lib/portage/const.py

		einfo "Prefixing shebangs ..."
		> "${T}/shebangs" || die
		while read -r -d $'\0' ; do
			local shebang=$(head -n1 "$REPLY")
			if [[ ${shebang} == "#!"* && ! ${shebang} == "#!${EPREFIX}/"* ]] ; then
				echo "${REPLY}" >> "${T}/shebangs" || die
			fi
		done < <(find . -type f -executable ! -name etc-update -print0)

		if [[ -s ${T}/shebangs ]]; then
			xargs sed -i -e "1s:^#!:#!${EPREFIX}:" < "${T}/shebangs" || die "sed failed"
		fi

		einfo "Adjusting make.globals, repos.conf and etc-update ..."
		hprefixify cnf/{make.globals,repos.conf} bin/etc-update

		if use prefix-guest ; then
			sed -e "s|^\(main-repo = \).*|\\1gentoo_prefix|" \
				-e "s|^\\[gentoo\\]|[gentoo_prefix]|" \
				-e "s|^\(sync-uri = \).*|\\1rsync://rsync.prefix.bitzolder.nl/gentoo-portage-prefix|" \
				-i cnf/repos.conf || die "sed failed"
		fi
	fi

	cd "${S}/cnf" || die
	if [[ -f "make.conf.example.${ARCH}".diff ]] ; then
		patch make.conf.example "make.conf.example.${ARCH}".diff || \
			die "Failed to patch make.conf.example"
	else
		eerror ""
		eerror "Portage does not have an arch-specific configuration for this arch."
		eerror "Please notify the arch maintainer about this issue. Using generic."
		eerror ""
	fi
}

python_compile_all() {
	local targets=()
	use doc && targets+=( docbook )
	use apidoc && targets+=( apidoc )

	if [[ ${targets[@]} ]]; then
		esetup.py "${targets[@]}"
	fi
}

python_install() {
	# Install sbin scripts to bindir for python-exec linking
	# they will be relocated in pkg_preinst()
	distutils-r1_python_install \
		--system-prefix="${EPREFIX}/usr" \
		--bindir="$(python_get_scriptdir)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--portage-bindir="${EPREFIX}/usr/lib/portage/${EPYTHON}" \
		--sbindir="$(python_get_scriptdir)" \
		--sysconfdir="${EPREFIX}/etc" \
		"${@}"
}

python_install_all() {
	distutils-r1_python_install_all

	local targets=()
	use doc && targets+=(
		install_docbook
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
	)
	use apidoc && targets+=(
		install_apidoc
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
	)

	# install docs
	if [[ ${targets[@]} ]]; then
		esetup.py "${targets[@]}"
	fi

	dotmpfiles "${FILESDIR}"/portage-{ccache,tmpdir}.conf

	# Due to distutils/python-exec limitations
	# these must be installed to /usr/bin.
	local sbin_relocations='archive-conf dispatch-conf emaint env-update etc-update fixpackages regenworld'
	einfo "Moving admin scripts to the correct directory"
	dodir /usr/sbin
	for target in ${sbin_relocations}; do
		einfo "Moving /usr/bin/${target} to /usr/sbin/${target}"
		mv "${ED}/usr/bin/${target}" "${ED}/usr/sbin/${target}" || die "sbin scripts move failed!"
	done
}

pkg_preinst() {
	if ! use build; then
		python_setup
		local sitedir=$(python_get_sitedir)
		[[ -d ${D}${sitedir} ]] || die "${D}${sitedir}: No such directory"
		env -u DISTDIR \
			-u PORTAGE_OVERRIDE_EPREFIX \
			-u PORTAGE_REPOSITORIES \
			-u PORTDIR \
			-u PORTDIR_OVERLAY \
			PYTHONPATH="${D}${sitedir}${PYTHONPATH:+:${PYTHONPATH}}" \
			"${PYTHON}" -m portage._compat_upgrade.default_locations || die

		env -u BINPKG_COMPRESS -u PORTAGE_REPOSITORIES \
			PYTHONPATH="${D}${sitedir}${PYTHONPATH:+:${PYTHONPATH}}" \
			"${PYTHON}" -m portage._compat_upgrade.binpkg_compression || die

		env -u FEATURES -u PORTAGE_REPOSITORIES \
			PYTHONPATH="${D}${sitedir}${PYTHONPATH:+:${PYTHONPATH}}" \
			"${PYTHON}" -m portage._compat_upgrade.binpkg_multi_instance || die
	fi

	# elog dir must exist to avoid logrotate error for bug #415911.
	# This code runs in preinst in order to bypass the mapping of
	# portage:portage to root:root which happens after src_install.
	keepdir /var/log/portage/elog
	# This is allowed to fail if the user/group are invalid for prefix users.
	if chown portage:portage "${ED}"/var/log/portage{,/elog} 2>/dev/null ; then
		chmod g+s,ug+rwx "${ED}"/var/log/portage{,/elog}
	fi

	if has_version "<${CATEGORY}/${PN}-2.3.77"; then
		elog "The emerge --autounmask option is now disabled by default, except for"
		elog "portions of behavior which are controlled by the --autounmask-use and"
		elog "--autounmask-license options. For backward compatibility, previous"
		elog "behavior of --autounmask=y and --autounmask=n is entirely preserved."
		elog "Users can get the old behavior simply by adding --autounmask to the"
		elog "make.conf EMERGE_DEFAULT_OPTS variable. For the rationale for this"
		elog "change, see https://bugs.gentoo.org/658648."
	fi
}

pkg_postinst() {
	# Warn about obsolete "enotice" script, bug #867010
	local bashrc=${EROOT}/etc/portage/profile/profile.bashrc
	if [[ -e ${bashrc} ]] && grep -q enotice "${bashrc}"; then
		eerror "Obsolete 'enotice' script detected!"
		eerror "Please remove this from ${bashrc} to avoid problems."
		eerror "See bug 867010 for more details."
	fi
}
