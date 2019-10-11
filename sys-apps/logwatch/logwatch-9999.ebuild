# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit tmpfiles

PATCHES=()

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://git.code.sf.net/p/logwatch/git ${PN}"
	inherit git-r3
else
	SRC_URI="mirror://sourceforge/${PN}/${P}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

DESCRIPTION="Analyzes and Reports on system logs"
HOMEPAGE="http://www.logwatch.org/"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="virtual/cron
	virtual/mta
	virtual/mailx
	dev-lang/perl
	dev-perl/Date-Calc
	dev-perl/Date-Manip
	dev-perl/Tie-IxHash
	dev-perl/Sys-CPU
	dev-perl/Sys-MemInfo"

src_install() {
	dodir /usr/share/logwatch/lib
	dodir /usr/share/logwatch/scripts/services
	dodir /usr/share/logwatch/scripts/shared
	dodir /usr/share/logwatch/default.conf/logfiles
	dodir /usr/share/logwatch/default.conf/services
	dodir /usr/share/logwatch/default.conf/html
	keepdir /etc/logwatch

	# logwatch.pl requires cache dir (bug #607668)
	newtmpfiles "${FILESDIR}"/logwatch.tmpfile ${PN}.conf

	newsbin scripts/logwatch.pl logwatch.pl

	exeinto /usr/share/logwatch/lib
	doexe lib/*.pm

	exeinto /usr/share/logwatch/scripts/services
	doexe scripts/services/*

	exeinto /usr/share/logwatch/scripts/shared
	doexe scripts/shared/*

	insinto /usr/share/logwatch/default.conf
	doins conf/logwatch.conf

	insinto /usr/share/logwatch/default.conf/logfiles
	doins conf/logfiles/*

	insinto /usr/share/logwatch/default.conf/services
	doins conf/services/*

	insinto /usr/share/logwatch/default.conf/html
	doins conf/html/*

	# Make sure logwatch is run before anything else #100243
	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/logwatch 00-logwatch

	doman logwatch.8
	dodoc README HOWTO-Customize-LogWatch

	# Do last due to insopts modification.
	insinto /usr/share/logwatch/scripts/logfiles
	insopts -m755
	doins -r scripts/logfiles/*
}

pkg_postinst() {
	# Migration from /etc/cron.daily/logwatch -> /etc/cron.daily/00-logwatch (bug #100243)
	if [[ -e ${ROOT}/etc/cron.daily/logwatch ]] ; then
		local md5=$(md5sum "${ROOT}"/etc/cron.daily/logwatch)
		[[ ${md5} == "edb003cbc0686ed4cf37db16025635f3" ]] \
			&& rm -f "${ROOT}"/etc/cron.daily/logwatch \
			|| ewarn "You have two logwatch files in /etc/cron.daily/"
	fi

	# Trigger cache dir creation to allow immediate use of logwatch (bug #607668)
	tmpfiles_process ${PN}.conf
}
