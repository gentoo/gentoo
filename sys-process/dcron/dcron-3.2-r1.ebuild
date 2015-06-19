# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/dcron/dcron-3.2-r1.ebuild,v 1.3 2012/05/24 05:48:48 vapier Exp $

inherit cron toolchain-funcs eutils flag-o-matic

DESCRIPTION="A cute little cron from Matt Dillon"
HOMEPAGE="http://apollo.backplane.com/FreeSrc/"
SRC_URI="http://apollo.backplane.com/FreeSrc/${PN}${PV//.}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/dcron-2.9-Makefile.patch
	epatch "${FILESDIR}"/dcron-3.2-pidfile.patch
	epatch "${FILESDIR}"/dcron-2.9-EDITOR.patch
	epatch "${FILESDIR}"/${P}-build.patch #181043
}

src_compile() {
	append-cppflags -D_GNU_SOURCE # for asprintf()
	emake CC="$(tc-getCC)" || die
}

src_install() {
	docrondir
	docron crond -m0700 -o root -g wheel
	docrontab

	dodoc CHANGELOG README "${FILESDIR}"/crontab
	doman crontab.1 crond.8

	newinitd "${FILESDIR}"/dcron.init dcron
	newconfd "${FILESDIR}"/dcron.confd dcron

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/dcron.logrotate dcron

	insinto /etc
	doins "${FILESDIR}"/crontab
}
