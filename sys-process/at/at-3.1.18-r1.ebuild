# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils flag-o-matic pam user systemd

DESCRIPTION="Queues jobs for later execution"
HOMEPAGE="http://packages.qa.debian.org/a/at.html"
SRC_URI="mirror://debian/pool/main/a/at/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="pam selinux"

DEPEND="virtual/mta
	>=sys-devel/autoconf-2.64
	sys-devel/bison
	>=sys-devel/flex-2.5.4a
	pam? ( virtual/pam )"
RDEPEND="virtual/mta
	virtual/logger
	selinux? ( sec-policy/selinux-at )"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.8-more-deny.patch
	"${FILESDIR}"/${PN}-3.1.14-Makefile.patch
	# fix parallel make issues, bug #244884
	"${FILESDIR}"/${PN}-3.1.10.2-Makefile.in-parallel-make-fix.patch
	"${FILESDIR}"/${PN}-3.1.13-configure.in-fix-PAM-automagick-dep.patch
	# Fix parallel make issue (bug #408375)
	"${FILESDIR}"/${PN}-3.1.13-parallel-make-fix.patch
	"${FILESDIR}"/${PN}-3.1.13-getloadavg.patch
)

pkg_setup() {
	enewgroup at 25
	enewuser at 25 -1 /var/spool/at/atjobs at
}

src_prepare() {
	default
	eautoconf
}

src_configure() {
	local myconf=()
	use pam || my_conf+=( --without-pam )
	use selinux && my_conf+=( --with-selinux )
	econf \
		--sysconfdir=/etc/at \
		--with-jobdir=/var/spool/at/atjobs \
		--with-atspool=/var/spool/at/atspool \
		--with-etcdir=/etc/at \
		--with-daemon_username=at \
		--with-daemon_groupname=at \
		${my_conf[@]}
}

src_install() {
	emake install IROOT="${D}"

	newinitd "${FILESDIR}"/atd.rc8 atd
	newconfd "${FILESDIR}"/atd.confd atd
	newpamd "${FILESDIR}"/at.pamd-3.1.13-r1 atd

	# Preserve existing .SEQ files (bug #386625)
	local seq_file="${ROOT}/var/spool/at/atjobs/.SEQ"
	if [ -f "${seq_file}" ] ; then
		einfo "Preserving existing .SEQ file (bug #386625)."
		cp -p "${seq_file}" "${D}"/var/spool/at/atjobs/ || die
	fi

	systemd_dounit "${FILESDIR}/atd.service"
}

pkg_postinst() {
	einfo "Forcing correct permissions on /var/spool/at"
	local atspooldir="${ROOT}/var/spool/at"
	chown at:at "${atspooldir}/atjobs"
	chmod 1770  "${atspooldir}/atjobs"
	chown at:at "${atspooldir}/atjobs/.SEQ"
	chmod 0600  "${atspooldir}/atjobs/.SEQ"
	chown at:at "${atspooldir}/atspool"
	chmod 1770  "${atspooldir}/atspool"
}
