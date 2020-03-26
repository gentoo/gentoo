# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="manpages-l10n-v${PV}"

DESCRIPTION="A somewhat comprehensive collection of Linux german man page translations"
HOMEPAGE="https://salsa.debian.org/manpages-l10n-team/manpages-l10n"
SRC_URI="https://salsa.debian.org/manpages-l10n-team/manpages-l10n/-/archive/v${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-3+ man-pages GPL-2+ GPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""

RDEPEND="virtual/man"
BDEPEND="app-text/po4a
	dev-lang/perl"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# some packages have their own translations
	local noinst_manpages=(
		# sys-apps/shadow
		po/de/man1/groups.1.po
		po/de/man1/su.1.po
		# sys-process/procps
		po/de/man1/tload.1.po
		po/de/man1/pwdx.1.po
		po/de/man1/uptime.1.po
		po/de/man1/pmap.1.po
		po/de/man1/pgrep.1.po
		po/de/man1/free.1.po
		po/de/man5/sysctl.conf.5.po
		po/de/man8/sysctl.8.po
		po/de/man8/vmstat.8.po
		# app-arch/xz-utils
		po/de/man1/xz.1.po
		po/de/man1/xzdiff.1.po
		po/de/man1/xzgrep.1.po
		po/de/man1/xzless.1.po
		po/de/man1/xzmore.1.po
	)
	rm "${noinst_manpages[@]}" || die

	eautoreconf
}

src_configure() {
	econf --enable-compression="none"
}

src_compile() { :; }

src_install() {
	emake mandir="${ED}"/usr/share/man install
	dodoc CHANGES.md README.md
}
