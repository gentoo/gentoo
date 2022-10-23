# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd prefix tmpfiles

DESCRIPTION="A man replacement that utilizes dbm instead of flat files"
HOMEPAGE="https://gitlab.com/cjwatson/man-db https://www.nongnu.org/man-db/"
if [[ ${PV} == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://gitlab.com/cjwatson/man-db.git"
else
	# TODO: Change tarballs to gitlab too...?
	SRC_URI="mirror://nongnu/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+manpager nls +seccomp selinux static-libs zlib"

CDEPEND="
	>=dev-libs/libpipeline-1.5.0
	sys-apps/groff
	sys-libs/gdbm:=
	seccomp? ( sys-libs/libseccomp )
	zlib? ( sys-libs/zlib )"
DEPEND="${CDEPEND}"
BDEPEND="app-arch/xz-utils
	virtual/pkgconfig
	nls? (
		>=app-text/po4a-0.45
		sys-devel/gettext
		virtual/libiconv
		virtual/libintl
	)"
RDEPEND="${CDEPEND}
	acct-group/man
	acct-user/man
	selinux? ( sec-policy/selinux-mandb )"
PDEPEND="manpager? ( app-text/manpager )"

PATCHES=(
	"${FILESDIR}"/man-db-2.9.3-sandbox-env-tests.patch
)

src_unpack() {
	if [[ ${PV} == *9999 ]] ; then
		git-r3_src_unpack

		# We need to mess with gnulib
		EGIT_REPO_URI="https://git.savannah.gnu.org/r/gnulib.git" \
		EGIT_CHECKOUT_DIR="${WORKDIR}/gnulib" \
		git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	default

	if [[ ${PV} == *9999 ]] ; then
		local bootstrap_opts=(
			--gnulib-srcdir=../gnulib
			--no-bootstrap-sync
			--copy
			--no-git
		)
		AUTORECONF="/bin/true" \
		LIBTOOLIZE="/bin/true" \
		sh ./bootstrap "${bootstrap_opts[@]}" || die

		eautoreconf
	fi

	hprefixify src/man_db.conf.in
	if use prefix ; then
		{
			echo "#"
			echo "# Added settings for Gentoo Prefix"
			[[ ${CHOST} == *-darwin* ]] && \
				echo "MANDATORY_MANPATH ${EPREFIX}/MacOSX.sdk/usr/share/man"
			echo "MANDATORY_MANPATH /usr/share/man"
		} >> src/man_db.conf.in
	fi
}

src_configure() {
	# Set sections we want to search by default
	local sections="1 1p 8 2 3 3p 4 5 6 7 9 0p tcl n l p o"
	sections+=" 1x 2x 3x 4x 5x 6x 7x 8x"
	case ${CHOST} in
		*-solaris*)
			# Solaris tends to use sections named after the pkgs that
			# owns them, in particular for libc functions we want those
			# sections
			local s
			for s in $(cd /usr/share/man/ && echo man*) ; do
				s=${s#man}
				[[ " ${sections} " != *" ${s} "* ]] && sections+=" ${s}"
			done
			;;
	esac

	export ac_cv_lib_z_gzopen=$(usex zlib)
	local myeconfargs=(
		--with-systemdtmpfilesdir="${EPREFIX}"/usr/lib/tmpfiles.d
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--disable-setuid # bug #662438
		--enable-cache-owner=man
		--with-sections="${sections}"

		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_with seccomp libseccomp)

		--with-db=gdbm
	)

	case ${CHOST} in
		*-solaris*|*-darwin*)
			myeconfargs+=(
				$(use_with nls libiconv-prefix "${EPREFIX}"/usr)
				$(use_with nls libintl-prefix "${EPREFIX}"/usr)
			)
			;;
	esac

	econf "${myeconfargs[@]}"

	# Disable color output from groff so that the manpager can add it. bug #184604
	if use manpager; then
		sed -i \
			-e '/^#DEFINE.*\<[nt]roff\>/{s:^#::;s:$: -c:}' \
			src/man_db.conf || die
	fi

	cat > 15man-db <<-EOF || die
	SANDBOX_PREDICT="/var/cache/man"
	EOF
}

src_install() {
	default
	dodoc docs/{HACKING.md,TODO}
	find "${ED}" -type f -name "*.la" -delete || die

	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/man-db.cron-r1 man-db # bug #289884

	insinto /etc/sandbox.d
	doins 15man-db
}

pkg_preinst() {
	local cachedir="${EROOT}/var/cache/man"
	# If the system was already exploited, and the attacker is hiding in the
	# cachedir of the old man-db, let's wipe them out.
	# see bug  #602588 comment 18
	local _replacing_version=
	local _setgid_vuln=0
	for _replacing_version in ${REPLACING_VERSIONS} ; do
		if ver_test '2.7.6.1-r2' -le "${_replacing_version}" ; then
			debug-print "Skipping security bug #602588 ... existing installation (${_replacing_version}) should not be affected!"
		else
			_setgid_vuln=1
			debug-print "Applying cleanup for security bug #602588"
		fi
	done
	[[ ${_setgid_vuln} -eq 1 ]] && rm -rf "${cachedir}"

	# Fall back to recreating the cachedir
	if [[ ! -d ${cachedir} ]] ; then
		mkdir -p "${cachedir}" || die
		chown man:man "${cachedir}" || die
	fi

	# Update the whatis cache
	if [[ -f ${cachedir}/whatis ]] ; then
		einfo "Cleaning ${cachedir} from sys-apps/man"
		find "${cachedir}" -type f '!' '(' -name index.bt -o -name index.db ')' -delete
	fi
}

pkg_postinst() {
	tmpfiles_process man-db.conf

	if [[ -n "${REPLACING_VERSIONS}" ]] ; then
		local _replacing_version=

		for _replacing_version in ${REPLACING_VERSIONS} ; do
			if [[ $(ver_cut 2 ${_replacing_version}) -lt 7 ]] ; then
				einfo "Rebuilding man-db from scratch with new database format!"
				su man -s /bin/sh -c 'mandb --quiet --create' 2>/dev/null

				# No need to run it again if we hit one
				break
			fi
		done
	fi
}
