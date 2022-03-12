# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic systemd

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/smartmontools/code/trunk/smartmontools"
	ESVN_PROJECT="smartmontools"
	inherit subversion
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
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

REQUIRED_USE="
	caps? ( daemon )
	static? ( !systemd )
"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	use static && append-ldflags -static

	# The build installs /etc/init.d/smartd, but we clobber it
	# in our src_install, so no need to manually delete it.
	local myeconfargs=(
		# bug #575292
		--with-drivedbdir="${EPREFIX}/var/db/${PN}"

		--with-initscriptdir="${EPREFIX}/etc/init.d"
		#--with-smartdscriptdir="${EPREFIX}/usr/share/${PN}"

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
	local db_path=/var/db/${PN}

	# Preserve timestamps
	insopts -m0644 -p

	if use daemon ; then
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
		doexe "${FILESDIR}"/${PN}-update-drivedb
	fi

	if use daemon || use update-drivedb ; then
		keepdir "${db_path}"

		# Install a copy of the initial drivedb.h to /usr/share/${PN}
		# for easy comparison for users if needed with the pristine version.
		insinto /usr/share/${PN}
		doins "${S}"/drivedb.h

		newenvd - 99smartmontools <<- EOF
			CONFIG_PROTECT="${EPREFIX}/${db_path}/drivedb.h"
		EOF
	fi

	# Bug #622072
	find "${ED}"/usr/share/doc -type f -exec chmod a-x '{}' \; || die
}
