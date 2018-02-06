# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools ltprune user versionator

DESCRIPTION="a man replacement that utilizes berkdb instead of flat files"
HOMEPAGE="http://www.nongnu.org/man-db/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="berkdb +gdbm +manpager nls selinux static-libs zlib"

CDEPEND="
	!sys-apps/man
	>=dev-libs/libpipeline-1.5.0
	sys-apps/groff
	berkdb? ( sys-libs/db:= )
	gdbm? ( sys-libs/gdbm:= )
	!berkdb? ( !gdbm? ( sys-libs/gdbm:= ) )
	zlib? ( sys-libs/zlib )
"
DEPEND="
	${CDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	nls? (
		>=app-text/po4a-0.45
		sys-devel/gettext
	)
"
RDEPEND="
	${CDEPEND}
	selinux? ( sec-policy/selinux-mandb )
"
PDEPEND="manpager? ( app-text/manpager )"

PATCHES=(
	"${FILESDIR}/${PN}-2.8.0-libseccomp_automagic.patch"
)

pkg_setup() {
	# Create user now as Makefile in src_install does setuid/chown
	enewgroup man 15
	enewuser man 13 -1 /usr/share/man man

	if (use gdbm && use berkdb) || (use !gdbm && use !berkdb) ; then #496150
		ewarn "Defaulting to USE=gdbm due to ambiguous berkdb/gdbm USE flag settings"
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	export ac_cv_lib_z_gzopen=$(usex zlib)
	local myeconfargs=(
		--docdir='$(datarootdir)'/doc/${PF}
		--with-systemdtmpfilesdir="${EPREFIX}"/usr/lib/tmpfiles.d
		--enable-setuid
		--enable-cache-owner=man
		--with-sections="1 1p 8 2 3 3p 4 5 6 7 9 0p tcl n l p o 1x 2x 3x 4x 5x 6x 7x 8x"
		$(use_enable nls)
		$(use_enable static-libs static)
		# fails to show any man page with this error message:
		# man: /usr/libexec/man-db/manconv -f UTF-8:ISO-8859-1 -t UTF-8//IGNORE: Bad system call
		# This will be made optional or hard enabled once the issue has been resolved.
		--without-libseccomp
		--with-db=$(usex gdbm gdbm $(usex berkdb db gdbm))
	)
	econf "${myeconfargs[@]}"

	# Disable color output from groff so that the manpager can add it. #184604
	sed -i \
		-e '/^#DEFINE.*\<[nt]roff\>/{s:^#::;s:$: -c:}' \
		src/man_db.conf || die
}

src_install() {
	default
	dodoc docs/{HACKING,TODO}
	prune_libtool_files

	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/man-db.cron man-db #289884
}

pkg_preinst() {
	local cachedir="${EROOT}var/cache/man"
	# If the system was already exploited, and the attacker is hiding in the
	# cachedir of the old man-db, let's wipe them out.
	# see bug  #602588 comment 18
	local _replacing_version=
	local _setgid_vuln=0
	for _replacing_version in ${REPLACING_VERSIONS}; do
		if version_is_at_least '2.7.6.1-r2' "${_replacing_version}"; then
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
	if [[ $(get_version_component_range 2 ${REPLACING_VERSIONS}) -lt 7 ]] ; then
		einfo "Rebuilding man-db from scratch with new database format!"
		mandb --quiet --create
	fi
}
