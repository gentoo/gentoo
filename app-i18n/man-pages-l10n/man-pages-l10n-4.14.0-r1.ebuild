# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A somewhat comprehensive collection of man page translations"
HOMEPAGE="https://manpages-l10n-team.pages.debian.net/manpages-l10n/"
SRC_URI="https://salsa.debian.org/manpages-l10n-team/${PN/-}/-/archive/${PV}/${P/-}.tar.bz2"
S="${WORKDIR}/${P/-}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
MY_L10N=(cs da de el es fi fr hu id it mk nb nl pl pt-BR ro sr sv uk vi)
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
	local f noinst_manpages=(
		# app-arch/xz-utils
		xz.1
		xzdec.1
		xzdiff.1
		xzgrep.1
		xzless.1
		xzmore.1
		# sys-apps/shadow
		groups.1
		su.1
		# sys-apps/sysvinit
		last.1
		mesg.1
		mountpoint.1
		utmpdump.1
		wall.1
		bootlogd.8
		halt.8
		killall5.8
		runlevel.8
		sulogin.8
		# sys-process/procps
		free.1
		pgrep.1
		pmap.1
		ps.1
		pwdx.1
		tload.1
		uptime.1
		sysctl.conf.5
		sysctl.8
		vmstat.8
		# sys-process/psmisc
		fuser.1
		killall.1
		peekfd.1
		prtstat.1
		pslog.1
		pstree.1
	)

	for f in "${noinst_manpages[@]}"; do
		rm po/*/"man${f##*.}/${f}.po" || die
	done
}

src_configure() {
	econf --enable-compression=none
}
