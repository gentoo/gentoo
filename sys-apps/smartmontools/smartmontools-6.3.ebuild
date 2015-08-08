# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit flag-o-matic systemd
if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://smartmontools.svn.sourceforge.net/svnroot/smartmontools/trunk/smartmontools"
	ESVN_PROJECT="smartmontools"
	inherit subversion autotools
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~x64-macos"
fi

DESCRIPTION="Self-Monitoring, Analysis and Reporting Technology System (S.M.A.R.T.) monitoring tools"
HOMEPAGE="http://smartmontools.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="caps minimal selinux static"

DEPEND="
	caps? (
		static? ( sys-libs/libcap-ng[static-libs] )
		!static? ( sys-libs/libcap-ng )
	)
	selinux? (
		sys-libs/libselinux
	)"
RDEPEND="${DEPEND}
	!minimal? ( virtual/mailx )
	selinux? ( sec-policy/selinux-smartmon )
"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		#./autogen.sh
		eautoreconf
	fi
}

src_configure() {
	use minimal && einfo "Skipping the monitoring daemon for minimal build."
	use static && append-ldflags -static
	# The build installs /etc/init.d/smartd, but we clobber it
	# in our src_install, so no need to manually delete it.
	econf \
		--with-docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--with-initscriptdir="${EPREFIX}/etc/init.d" \
		$(use_with caps libcap-ng) \
		$(use_with selinux) \
		$(systemd_with_unitdir)
}

src_install() {
	if use minimal ; then
		dosbin smartctl
		doman smartctl.8
	else
		default
		newinitd "${FILESDIR}"/smartd-r1.rc smartd
		newconfd "${FILESDIR}"/smartd.confd smartd
	fi
}
