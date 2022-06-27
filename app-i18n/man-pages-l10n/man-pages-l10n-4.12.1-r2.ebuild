# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN/-}-v${PV}"
DESCRIPTION="A somewhat comprehensive collection of man page translations"
HOMEPAGE="https://manpages-l10n-team.pages.debian.net/manpages-l10n/"
SRC_URI="https://salsa.debian.org/manpages-l10n-team/manpages-l10n/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
MY_L10N=(cs da de el es fi fr hu id it mk nb nl pl pt-BR ro sr sv)
IUSE="${MY_L10N[@]/#/l10n_}"
REQUIRED_USE="|| ( ${MY_L10N[@]/#/l10n_} )"

RDEPEND="virtual/man
	l10n_de? ( !app-i18n/man-pages-de )
	l10n_fr? ( !app-i18n/man-pages-fr )
	l10n_it? ( !app-i18n/man-pages-it )
	l10n_nl? ( !app-i18n/man-pages-nl )
	l10n_pl? ( !app-i18n/man-pages-pl )"

BDEPEND="app-text/po4a
	dev-lang/perl"

DOCS=(AUTHORS.md CHANGES.md CONTRIBUTING.md README.md)

src_prepare() {
	default
	sed -i -e "/^SUBDIRS/s/=.*/= ${L10N//-/_}/" po/Makefile.{am,in} || die

	# some packages have their own translations
	local noinst_manpages=(
		# app-arch/xz-utils
		de/xz.1
		de/xzdec.1
		de/xzdiff.1
		de/xzgrep.1
		de/xzless.1
		de/xzmore.1
		# sys-apps/shadow
		{cs,de,es,hu,nl,pl}/groups.1
		de/su.1
		# sys-apps/sysvinit
		de/last.1
		de/mesg.1
		de/mountpoint.1
		de/utmpdump.1
		de/wall.1
		{de,es,fr,pl}/initscript.5
		{de,es,fr,pl}/inittab.5
		fr/bootlogd.8
		de/halt.8
		{de,es,fr,pl}/init.8
		{fr,pl}/killall5.8
		{fr,pl}/pidof.8
		de/runlevel.8
		de/sulogin.8
		# sys-process/procps
		{de,fr,pl}/free.1
		{de,fr}/pgrep.1
		{de,fr}/pmap.1
		{de,fr,pl}/ps.1
		{de,fr}/pwdx.1
		{de,fr}/tload.1
		{de,fr,pl}/uptime.1
		{de,fr}/sysctl.conf.5
		{de,fr}/sysctl.8
		{de,fr}/vmstat.8
		# sys-process/psmisc
		{de,nl,pl}/fuser.1
		{de,pl}/killall.1
		de/peekfd.1
		de/prtstat.1
		de/pslog.1
		{de,pl}/pstree.1
	)
	printf '%s\n' "${noinst_manpages[@]}" \
		| sed 's%^\(.*\)/\(.*\)\.\(.*\)$%po/\1/man\3/\2.\3.po%' | xargs rm
	assert
}

src_configure() {
	econf --enable-compression=none
}
