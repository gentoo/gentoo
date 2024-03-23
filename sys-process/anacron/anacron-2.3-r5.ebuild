# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A periodic command scheduler"
HOMEPAGE="https://anacron.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~riscv x86"

DEPEND="
	acct-group/cron
	sys-process/cronbase
"

RDEPEND="
	${DEPEND}
	virtual/mta
"

BDEPEND="acct-group/cron"

PATCHES=(
	"${FILESDIR}"/${P}-compile-fix-from-debian.patch
	"${FILESDIR}"/${P}-headers.patch
)

src_prepare() {
	default

	sed -i \
		-e '/^CFLAGS/{s:=:+=:;s:-O2::}' \
		Makefile || die
}

src_configure() {
	tc-export CC
}

src_install() {
	# This does not work if the directory already exists.
	diropts -m0750 -o root -g cron
	keepdir /var/spool/${PN}

	doman ${PN}tab.5 ${PN}.8
	newinitd "${FILESDIR}/${PN}.rc6" "${PN}"
	dodoc ChangeLog README TODO
	dosbin "${PN}"

	insinto /etc
	doins "${FILESDIR}/${PN}tab"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Schedule the command \"anacron -s\" as a daily cron-job (preferably"
		elog "at some early morning hour).  This will make sure that jobs are run"
		elog "when the systems is left running for a night."
		echo
		elog "Update /etc/anacrontab to include what you want anacron to run."
		echo
		elog "You may wish to read the Gentoo Linux Cron Guide, which can be"
		elog "found online at:"
		elog "    https://wiki.gentoo.org/wiki/Cron"
	fi
}
