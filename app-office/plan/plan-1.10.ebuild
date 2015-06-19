# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/plan/plan-1.10.ebuild,v 1.1 2014/01/25 03:36:00 creffett Exp $

EAPI=5

inherit eutils

DESCRIPTION="Motif based schedule planner"
HOMEPAGE="http://www.bitrot.de/plan.html"
SRC_URI="ftp://ftp.fu-berlin.de/unix/X11/apps/plan/${P}.tar.gz
	mirror://gentoo/${P}-gentoo.tar.xz"

LICENSE="GPL-2+" #448646
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

DEPEND="
	x11-libs/libXpm
	>=x11-libs/motif-2.3:0
"
RDEPEND="${DEPEND}"

QA_PRESTRIPPED="
/usr/bin/netplan
/usr/bin/plan
"
src_prepare() {
	epatch "${WORKDIR}"/${P}-patches/*.patch
}

src_compile() {
	pushd src
	emake CC=$(tc-getCC) SHARE=/usr/share/plan linux
	popd
}

src_install() {
	pushd src
	emake \
		DESTDIR="${D}" \
		SHARE=/usr/share/plan \
		install
	keepdir /usr/share/plan/netplan.dir
	popd

	dodoc HISTORY README

	pushd misc
	doman netplan.1 plan.1 plan.4
	insinto /usr/share/${PN}/misc
	doins netplan.boot BlackWhite Monochrome plan.fti Plan.xpm plan.xpm
	exeinto /usr/share/${PN}/misc
	doexe Killpland cvs vsc msschedule2plan plan2vcs
	popd

	pushd web
	insinto /usr/share/${PN}/web
	doins help.html bottom.html cgi-lib.pl common.pl holiday_webplan rtsban.jpg
	exeinto /usr/share/${PN}/web
	doexe *.cgi
	popd
}

pkg_postinst() {
	elog
	elog " Check /usr/share/${PN}/holiday for examples to set your"
	elog " ~/.holiday according to your country."
	elog
	elog " WebPlan ${PV} can be found in /usr/share/${PN}/web."
	elog
}
