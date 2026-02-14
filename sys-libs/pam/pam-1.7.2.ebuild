# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="Linux-${PN^^}-${PV}"

# Avoid QA warnings
# Can reconsider w/ EAPI 8 and IDEPEND, bug #810979
TMPFILES_OPTIONAL=1

inherit db-use flag-o-matic meson-multilib user-info

DESCRIPTION="Linux-PAM (Pluggable Authentication Modules)"
HOMEPAGE="https://github.com/linux-pam/linux-pam"

if [[ ${PV} == *_p* ]] ; then
	PAM_COMMIT="e634a3a9be9484ada6e93970dfaf0f055ca17332"
	SRC_URI="
		https://github.com/linux-pam/linux-pam/archive/${PAM_COMMIT}.tar.gz -> ${P}.gh.tar.gz
	"
	S="${WORKDIR}"/linux-${PN}-${PAM_COMMIT}
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/pam.asc
	inherit verify-sig

	SRC_URI="
		https://github.com/linux-pam/linux-pam/releases/download/v${PV}/${MY_P}.tar.xz
		verify-sig? ( https://github.com/linux-pam/linux-pam/releases/download/v${PV}/${MY_P}.tar.xz.asc )
	"
	S="${WORKDIR}/${MY_P}"

	BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-pam-20260122 )"
fi

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="audit berkdb elogind examples debug nis nls selinux systemd"
REQUIRED_USE="?? ( elogind systemd )"

# meson.build specifically checks for bison and then byacc
# also requires xsltproc
BDEPEND+="
	acct-group/shadow
	|| ( sys-devel/bison dev-util/byacc )
	app-text/docbook-xsl-ns-stylesheets
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
DEPEND="
	virtual/libcrypt:=[${MULTILIB_USEDEP}]
	>=virtual/libintl-0-r1[${MULTILIB_USEDEP}]
	audit? ( >=sys-process/audit-2.2.2[${MULTILIB_USEDEP}] )
	berkdb? ( >=sys-libs/db-4.8.30-r1:=[${MULTILIB_USEDEP}] )
	!berkdb? ( sys-libs/gdbm:=[${MULTILIB_USEDEP}] )
	elogind? ( >=sys-auth/elogind-254 )
	selinux? ( >=sys-libs/libselinux-2.2.2-r4[${MULTILIB_USEDEP}] )
	systemd? ( >=sys-apps/systemd-254:= )
	nis? (
		net-libs/libnsl:=[${MULTILIB_USEDEP}]
		>=net-libs/libtirpc-0.2.4-r2:=[${MULTILIB_USEDEP}]
	)
"
RDEPEND="${DEPEND}
	acct-group/shadow
"
PDEPEND=">=sys-auth/pambase-20200616"

src_configure() {
	# meson.build sets -Wl,--fatal-warnings and with e.g. mold, we get:
	#  cannot assign version `global` to symbol `pam_sm_open_session`: symbol not found
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	# Do not let user's BROWSER setting mess us up, bug #549684
	unset BROWSER

	meson-multilib_src_configure
}

multilib_src_configure() {
	local machine_file="${T}/meson.${CHOST}.${ABI}.ini.local"
	# Workaround for docbook5 not being packaged (bug #913087#c4)
	# It's only used for validation of output, so stub it out.
	# Also, stub out elinks+w3m which are only used for an index.
	cat >> "${machine_file}" <<-EOF || die
	[binaries]
	xmlcatalog='true'
	xmllint='true'
	elinks='true'
	w3m='true'
	EOF

	local emesonargs=(
		--native-file "${machine_file}"

		$(meson_feature audit)
		$(meson_native_use_bool examples)
		$(meson_use debug pam-debug)
		$(meson_feature nis)
		$(meson_feature nls i18n)
		$(meson_feature selinux)

		-Disadir='.'
		-Dxml-catalog="${BROOT}"/etc/xml/catalog
		-Dsbindir="${EPREFIX}"/sbin
		-Dsecuredir="${EPREFIX}"/$(get_libdir)/security
		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}
		-Dhtmldir="${EPREFIX}"/usr/share/doc/${PF}/html
		-Dpdfdir="${EPREFIX}"/usr/share/doc/${PF}/pdf
		-Dvendordir="${EPREFIX}"/usr/share/pam

		$(meson_native_enabled docs)

		-Dpam_unix=enabled

		# TODO: wire this up now it's more useful as of 1.5.3 (bug #931117)
		-Deconf=disabled

		# TODO: lastlog is enabled again for now by us as elogind support
		# wasn't available at first. Even then, disabling lastlog will
		# probably need a news item.
		$(meson_native_use_feature systemd logind)
		$(meson_native_use_feature elogind)
		$(meson_feature !elibc_musl pam_lastlog)
	)

	if use berkdb; then
		local dbver
		dbver="$(db_findver sys-libs/db)" || die "could not find db version"
		local -x CPPFLAGS="${CPPFLAGS} -I$(db_includedir "${dbver}")"
		emesonargs+=(
			-Ddb=db
			-Ddb-uniquename="-${dbver}"
		)
	else
		emesonargs+=(
			-Ddb=gdbm
		)
	fi

	# This whole weird has_version libxcrypt block can go once
	# musl systems have libxcrypt[system] if we ever make
	# that mandatory. See bug #867991.
	#if use elibc_musl && ! has_version sys-libs/libxcrypt[system] ; then
	#	# Avoid picking up symbol-versioned compat symbol on musl systems
	#	export ac_cv_search_crypt_gensalt_rn=no
	#
	#	# Need to avoid picking up the libxcrypt headers which define
	#	# CRYPT_GENSALT_IMPLEMENTS_AUTO_ENTROPY.
	#	cp "${ESYSROOT}"/usr/include/crypt.h "${T}"/crypt.h || die
	#	append-cppflags -I"${T}"
	#fi

	meson_src_configure
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die

	fowners :shadow /sbin/unix_chkpwd
	fperms g+s /sbin/unix_chkpwd

	# tmpfiles.eclass is impossible to use because
	# there is the pam -> tmpfiles -> systemd -> pam dependency loop
	dodir /usr/lib/tmpfiles.d

	cat ->> "${ED}"/usr/lib/tmpfiles.d/${CATEGORY}-${PN}.conf <<-_EOF_
		d /run/faillock 0755 root root
	_EOF_
	use selinux && cat ->> "${ED}"/usr/lib/tmpfiles.d/${CATEGORY}-${PN}-selinux.conf <<-_EOF_
		d /run/sepermit 0755 root root
	_EOF_
}

pkg_postinst() {
	if [[ -n ${ROOT} ]]; then
		# Portage does not currently update the gid on installed files
		# based on ${EROOT}/etc/group.
		local gid=$(egetent group shadow | cut -d: -f3)
		if [[ -n ${gid} ]]; then
			chgrp "${gid}" "${EROOT}/sbin/unix_chkpwd" &&
			chmod g+s "${EROOT}/sbin/unix_chkpwd"
		fi
	fi
	ewarn "Some software with pre-loaded PAM libraries might experience"
	ewarn "warnings or failures related to missing symbols and/or versions"
	ewarn "after any update. While unfortunate this is a limit of the"
	ewarn "implementation of PAM and the software, and it requires you to"
	ewarn "restart the software manually after the update."
	ewarn ""
	ewarn "You can get a list of such software running a command like"
	ewarn "  lsof / | grep -E -i 'del.*libpam\\.so'"
	ewarn ""
	ewarn "Alternatively, simply reboot your system."
}
