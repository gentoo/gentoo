# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic systemd
if [[ ${PV} == 9999 ]] ; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/smartmontools/code/trunk/smartmontools"
	ESVN_PROJECT="smartmontools"
	inherit autotools subversion
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
fi

DESCRIPTION="Tools to monitor storage systems to provide advanced warning of disk degradation"
HOMEPAGE="https://www.smartmontools.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="caps +daemon selinux static systemd +update-drivedb"

DEPEND="
	caps? (
		static? ( sys-libs/libcap-ng:=[static-libs] )
		!static? ( sys-libs/libcap-ng:= )
	)
	selinux? (
		sys-libs/libselinux:=
	)
"
RDEPEND="
	${DEPEND}
	daemon? ( virtual/mailx )
	selinux? ( sec-policy/selinux-smartmon )
	systemd? ( sys-apps/systemd )
	update-drivedb? (
		app-crypt/gnupg
		|| (
			net-misc/curl
			net-misc/wget
			www-client/lynx
			dev-vcs/subversion
		)
	)
"

REQUIRED_USE="(
	caps? ( daemon )
	static? ( !systemd )
)"

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	fi
}

src_configure() {
	use static && append-ldflags -static
	# The build installs /etc/init.d/smartd, but we clobber it
	# in our src_install, so no need to manually delete it.
	myeconfargs=(
		--with-drivedbdir="${EPREFIX}/var/db/${PN}" #575292
		--with-initscriptdir="${EPREFIX}/etc/init.d"
		#--with-smartdscriptdir="${EPREFIX}/usr/share/${PN}"
		--with-systemdenvfile=no
		$(use_with caps libcap-ng)
		$(use_with selinux)
		$(use_with systemd libsystemd)
		$(use_with update-drivedb gnupg)
		$(use_with update-drivedb update-smart-drivedb)
		$(usex systemd "--with-systemdsystemunitdir=$(systemd_get_systemunitdir)" '')
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	local db_path="/var/db/${PN}"
	insopts -m0644 -p # preserve timestamps

	if use daemon; then
		default

		newinitd "${FILESDIR}"/smartd-r1.rc smartd
		newconfd "${FILESDIR}"/smartd.confd smartd
	else
		dosbin smartctl
		doman smartctl.8

		local DOCS=( AUTHORS ChangeL* COPYING INSTALL NEWS README TODO )
		einstalldocs
	fi

	if use update-drivedb ; then
		if ! use daemon; then
			dosbin "${S}"/update-smart-drivedb
		fi

		exeinto /etc/cron.monthly
		doexe "${FILESDIR}/${PN}-update-drivedb"
	fi

	if use daemon || use update-drivedb; then
		keepdir "${db_path}"

		# Install a copy of the initial drivedb.h to /usr/share/${PN}
		# so that we can access that file later in pkg_postinst
		# even when dealing with binary packages (bug #575292)
		insinto /usr/share/${PN}
		doins "${S}"/drivedb.h
	fi

	# Make sure we never install drivedb.h into the db location
	# of the actual image so we don't record hashes because user
	# can modify that file
	rm -f "${ED}${db_path}/drivedb.h" || die

	# Bug #622072
	find "${ED}"/usr/share/doc -type f -exec chmod a-x '{}' \; || die
}

pkg_postinst() {
	if use daemon || use update-drivedb; then
		local initial_db_file="${EROOT}/usr/share/${PN}/drivedb.h"
		local db_path="${EROOT}/var/db/${PN}"

		if [[ ! -f "${db_path}/drivedb.h" ]] ; then
			# No initial database found
			cp "${initial_db_file}" "${db_path}" || die
			einfo "Default drive database which was shipped with this release of ${PN}"
			einfo "has been installed to '${db_path}'."
		else
			ewarn "WARNING: There's already a drive database in '${db_path}'!"
			ewarn "Because we cannot determine if this database is untouched"
			ewarn "or was modified by the user you have to manually update the"
			ewarn "drive database:"
			ewarn ""
			ewarn "a) Replace '${db_path}/drivedb.h' by the database shipped with this"
			ewarn "   release which can be found in '${initial_db_file}', i.e."
			ewarn ""
			ewarn "     cp \"${initial_db_file}\" \"${db_path}\""
			ewarn ""
			ewarn "b) Run the following command as root:"
			ewarn ""
			ewarn "     /usr/sbin/update-smart-drivedb"

			if ! use update-drivedb ; then
				ewarn ""
				ewarn "However, 'update-smart-drivedb' requires that you re-emerge ${PN}"
				ewarn "with USE='update-drivedb'."
			fi
		fi
	fi
}
