# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/shadow/shadow-4.2.1-r1.ebuild,v 1.2 2015/04/30 06:48:16 vapier Exp $

EAPI=4

inherit eutils libtool toolchain-funcs pam multilib autotools

DESCRIPTION="Utilities to deal with user accounts"
HOMEPAGE="http://shadow.pld.org.pl/ http://pkg-shadow.alioth.debian.org/"
SRC_URI="http://pkg-shadow.alioth.debian.org/releases/${P}.tar.xz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="acl audit cracklib nls pam selinux skey xattr"
# Taken from the man/Makefile.am file.
LANGS=( cs da de es fi fr hu id it ja ko pl pt_BR ru sv tr zh_CN zh_TW )
IUSE+=" $(printf 'linguas_%s ' ${LANGS[*]})"

RDEPEND="acl? ( sys-apps/acl )
	audit? ( sys-process/audit )
	cracklib? ( >=sys-libs/cracklib-2.7-r3 )
	pam? ( virtual/pam )
	skey? ( sys-auth/skey )
	selinux? (
		>=sys-libs/libselinux-1.28
		sys-libs/libsemanage
	)
	nls? ( virtual/libintl )
	xattr? ( sys-apps/attr )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	pam? ( >=sys-auth/pambase-20150213 )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.1.3-dots-in-usernames.patch #22920
	epatch "${FILESDIR}"/${P}-cross-size-checks.patch
	epatch_user
	# https://github.com/shadow-maint/shadow/pull/5
	mv configure.{in,ac} || die
	eautoreconf
	#elibtoolize
}

src_configure() {
	tc-is-cross-compiler && export ac_cv_func_setpgrp_void=yes
	econf \
		--without-group-name-max-length \
		--without-tcb \
		--enable-shared=no \
		--enable-static=yes \
		$(use_with acl) \
		$(use_with audit) \
		$(use_with cracklib libcrack) \
		$(use_with pam libpam) \
		$(use_with skey) \
		$(use_with selinux) \
		$(use_enable nls) \
		$(use_with elibc_glibc nscd) \
		$(use_with xattr attr)
	has_version 'sys-libs/uclibc[-rpc]' && sed -i '/RLOGIN/d' config.h #425052

	if use nls ; then
		local l langs="po" # These are the pot files.
		for l in ${LANGS[*]} ; do
			use linguas_${l} && langs+=" ${l}"
		done
		sed -i "/^SUBDIRS = /s:=.*:= ${langs}:" man/Makefile || die
	fi
}

set_login_opt() {
	local comment="" opt=$1 val=$2
	if [[ -z ${val} ]]; then
		comment="#"
		sed -i \
			-e "/^${opt}\>/s:^:#:" \
			"${ED}"/etc/login.defs || die
	else
		sed -i -r \
			-e "/^#?${opt}\>/s:.*:${opt} ${val}:" \
			"${ED}"/etc/login.defs
	fi
	local res=$(grep "^${comment}${opt}\>" "${ED}"/etc/login.defs)
	einfo "${res:-Unable to find ${opt} in /etc/login.defs}"
}

src_install() {
	emake DESTDIR="${D}" suidperms=4711 install

	# Remove libshadow and libmisc; see bug 37725 and the following
	# comment from shadow's README.linux:
	#   Currently, libshadow.a is for internal use only, so if you see
	#   -lshadow in a Makefile of some other package, it is safe to
	#   remove it.
	rm -f "${ED}"/{,usr/}$(get_libdir)/lib{misc,shadow}.{a,la}

	insinto /etc
	if ! use pam ; then
		insopts -m0600
		doins etc/login.access etc/limits
	fi

	# needed for 'useradd -D'
	insinto /etc/default
	insopts -m0600
	doins "${FILESDIR}"/default/useradd

	# move passwd to / to help recover broke systems #64441
	mv "${ED}"/usr/bin/passwd "${ED}"/bin/ || die
	dosym /bin/passwd /usr/bin/passwd

	cd "${S}"
	insinto /etc
	insopts -m0644
	newins etc/login.defs login.defs

	set_login_opt CREATE_HOME yes
	if ! use pam ; then
		set_login_opt MAIL_CHECK_ENAB no
		set_login_opt SU_WHEEL_ONLY yes
		set_login_opt CRACKLIB_DICTPATH /usr/$(get_libdir)/cracklib_dict
		set_login_opt LOGIN_RETRIES 3
		set_login_opt ENCRYPT_METHOD SHA512
		set_login_opt CONSOLE
	else
		dopamd "${FILESDIR}"/pam.d-include/shadow

		for x in chpasswd chgpasswd newusers; do
			newpamd "${FILESDIR}"/pam.d-include/passwd ${x}
		done

		for x in chage chsh chfn \
				 user{add,del,mod} group{add,del,mod} ; do
			newpamd "${FILESDIR}"/pam.d-include/shadow ${x}
		done

		# comment out login.defs options that pam hates
		local opt sed_args=()
		for opt in \
			CHFN_AUTH \
			CONSOLE \
			CRACKLIB_DICTPATH \
			ENV_HZ \
			ENVIRON_FILE \
			FAILLOG_ENAB \
			FTMP_FILE \
			LASTLOG_ENAB \
			MAIL_CHECK_ENAB \
			MOTD_FILE \
			NOLOGINS_FILE \
			OBSCURE_CHECKS_ENAB \
			PASS_ALWAYS_WARN \
			PASS_CHANGE_TRIES \
			PASS_MIN_LEN \
			PORTTIME_CHECKS_ENAB \
			QUOTAS_ENAB \
			SU_WHEEL_ONLY
		do
			set_login_opt ${opt}
			sed_args+=( -e "/^#${opt}\>/b pamnote" )
		done
		sed -i "${sed_args[@]}" \
			-e 'b exit' \
			-e ': pamnote; i# NOTE: This setting should be configured via /etc/pam.d/ and not in this file.' \
			-e ': exit' \
			"${ED}"/etc/login.defs || die

		# remove manpages that pam will install for us
		# and/or don't apply when using pam
		find "${ED}"/usr/share/man \
			'(' -name 'limits.5*' -o -name 'suauth.5*' ')' \
			-delete

		# Remove pam.d files provided by pambase.
		rm "${ED}"/etc/pam.d/{login,passwd,su} || die
	fi

	# Remove manpages that are handled by other packages
	find "${ED}"/usr/share/man \
		'(' -name id.1 -o -name passwd.5 -o -name getspnam.3 ')' \
		-delete

	cd "${S}"
	dodoc ChangeLog NEWS TODO
	newdoc README README.download
	cd doc
	dodoc HOWTO README* WISHLIST *.txt
}

pkg_preinst() {
	rm -f "${EROOT}"/etc/pam.d/system-auth.new \
		"${EROOT}/etc/login.defs.new"
}

pkg_postinst() {
	# Enable shadow groups.
	if [ ! -f "${EROOT}"/etc/gshadow ] ; then
		if grpck -r -R "${EROOT}" 2>/dev/null ; then
			grpconv -R "${EROOT}"
		else
			ewarn "Running 'grpck' returned errors.  Please run it by hand, and then"
			ewarn "run 'grpconv' afterwards!"
		fi
	fi

	einfo "The 'adduser' symlink to 'useradd' has been dropped."
}
