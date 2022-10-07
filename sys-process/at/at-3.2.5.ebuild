# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools pam systemd

MY_P="${PN}_${PV}"

DESCRIPTION="Queues jobs for later execution"
HOMEPAGE="http://blog.calhariz.com/index.php/tag/at https://packages.qa.debian.org/a/at.html"
SRC_URI="http://software.calhariz.com/at/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/a/at/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="pam selinux"

DEPEND="
	acct-group/at
	acct-user/at
	virtual/mta
	pam? ( sys-libs/pam )
	selinux? ( sys-libs/libselinux )
"
RDEPEND="${DEPEND}
	virtual/mta
	virtual/logger
	selinux? ( sec-policy/selinux-at )
"
BDEPEND="
	>=sys-devel/autoconf-2.64
	sys-devel/bison
	>=sys-devel/flex-2.5.4a
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.8-more-deny.patch
	"${FILESDIR}"/${PN}-3.1.14-Makefile.patch
	# fix parallel make issues, bug #244884
	"${FILESDIR}"/${PN}-3.1.10.2-Makefile.in-parallel-make-fix.patch
	"${FILESDIR}"/${PN}-3.1.13-configure.in-fix-PAM-automagick-dep.patch
	# Fix parallel make issue (bug #408375)
	"${FILESDIR}"/${PN}-3.1.13-parallel-make-fix.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/at
		--with-jobdir="${EPREFIX}"/var/spool/at/atjobs
		--with-atspool="${EPREFIX}"/var/spool/at/atspool
		--with-etcdir="${EPREFIX}"/etc/at
		--with-daemon_username=at
		--with-daemon_groupname=at
		$(usex pam '' --without-pam)
		$(use_with selinux)
	)
	econf ${myeconfargs[@]}
}

src_install() {
	default

	newinitd "${FILESDIR}"/atd.rc9 atd
	newconfd "${FILESDIR}"/atd.confd atd

	if use pam ; then
		newpamd "${FILESDIR}"/at.pamd-3.1.13-r1 atd
	fi

	# Preserve existing .SEQ files (bug #386625)
	local seq_file="${EROOT}/var/spool/at/atjobs/.SEQ"
	if [[ -f "${seq_file}" ]] ; then
		einfo "Preserving existing .SEQ file (bug #386625)."
		cp -p "${seq_file}" "${ED}"/var/spool/at/atjobs/ || die
	fi

	systemd_dounit "${FILESDIR}/atd.service"
	keepdir /var/spool/at/atspool
}

pkg_postinst() {
	einfo "Forcing correct permissions on /var/spool/at"
	local atspooldir="${EROOT}/var/spool/at"
	chown at:at "${atspooldir}/atjobs"
	chmod 1770  "${atspooldir}/atjobs"
	chown at:at "${atspooldir}/atjobs/.SEQ"
	chmod 0600  "${atspooldir}/atjobs/.SEQ"
	chown at:at "${atspooldir}/atspool"
	chmod 1770  "${atspooldir}/atspool"
}
