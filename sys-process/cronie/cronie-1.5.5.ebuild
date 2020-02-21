# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools cron flag-o-matic pam systemd user

DESCRIPTION="Cronie is a standard UNIX daemon cron based on the original vixie-cron"
HOMEPAGE="https://github.com/cronie-crond/cronie"
SRC_URI="https://github.com/cronie-crond/cronie/archive/${P}.tar.gz"

LICENSE="ISC BSD BSD-2 GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
IUSE="+anacron +inotify pam selinux"

DEPEND="
	pam? ( sys-libs/pam )
	anacron? ( !sys-process/anacron
		elibc_musl? ( sys-libs/obstack-standalone )
		elibc_uclibc? ( sys-libs/obstack-standalone )
	)
"
RDEPEND="${DEPEND}
	sys-apps/debianutils
"

#cronie supports /etc/crontab
CRON_SYSTEM_CRONTAB="yes"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.3-systemd.patch"
)

pkg_setup() {
	enewgroup crontab
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with inotify)
		$(use_with pam)
		$(use_with selinux)
		$(use_enable anacron)
		--enable-syscrontab
		--with-daemon_username=cron
		--with-daemon_groupname=cron
	)

	if use anacron; then
		if use elibc_musl || use elibc_uclibc ; then
			append-cflags "-lobstack"
		fi
	fi
	SPOOL_DIR="/var/spool/cron/crontabs" \
	ANACRON_SPOOL_DIR="/var/spool/anacron" \
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	docrondir -m 1730 -o root -g crontab
	fowners root:crontab /usr/bin/crontab
	fperms 2751 /usr/bin/crontab

	newconfd "${S}"/crond.sysconfig ${PN}

	insinto /etc
	newins "${FILESDIR}/${PN}-crontab" crontab
	newins "${FILESDIR}/${PN}-1.2-cron.deny" cron.deny

	insinto /etc/cron.d
	doins contrib/0hourly

	newinitd "${FILESDIR}/${PN}-1.3-initd" ${PN}
	newpamd "${FILESDIR}/${PN}-1.4.3-pamd" crond

	systemd_newunit contrib/cronie.systemd cronie.service

	if use anacron ; then
		local anacrondir="/var/spool/anacron"
		keepdir ${anacrondir}
		fowners root:cron ${anacrondir}
		fperms 0750 ${anacrondir}

		insinto /etc
		doins contrib/anacrontab

		insinto /etc/cron.hourly
		doins contrib/0anacron
		fperms 0750 /etc/cron.hourly/0anacron
	else
		insinto /etc/cron.d
		doins contrib/dailyjobs
	fi

	einstalldocs
}

pkg_postinst() {
	cron_pkg_postinst

	if [[ -n "${REPLACING_VERSIONS}" ]] ; then
		ewarn "You should restart ${PN} daemon or else you might experience segfaults"
		ewarn "or ${PN} not working reliably anymore."
		einfo "(see https://bugs.gentoo.org/557406 for details.)"
	fi
}
