# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Motif based schedule planner"
HOMEPAGE="https://www.bitrot.de/plan.html"
SRC_URI="
	ftp://ftp.fu-berlin.de/unix/X11/apps/plan/${P}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${P}-patches.txz"

LICENSE="GPL-2+" #448646
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/motif:0"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex"

PATCHES=( "${WORKDIR}"/patches )

src_compile() {
	emake -C src CC="$(tc-getCC)" SHARE=/usr/share/plan linux
}

src_install() {
	emake -C src \
		DESTDIR="${ED}" \
		SHARE=/usr/share/plan \
		install
	keepdir /usr/share/plan/netplan.dir

	dodoc HISTORY README

	pushd misc >/dev/null || die
	doman netplan.1 plan.1 plan.4
	insinto /usr/share/${PN}/misc
	doins netplan.boot BlackWhite Monochrome plan.fti Plan.xpm plan.xpm
	exeinto /usr/share/${PN}/misc
	doexe Killpland cvs vsc msschedule2plan plan2vcs
	popd >/dev/null || die

	pushd web >/dev/null || die
	insinto /usr/share/${PN}/web
	doins help.html bottom.html cgi-lib.pl common.pl holiday_webplan rtsban.jpg
	exeinto /usr/share/${PN}/web
	doexe *.cgi
	popd >/dev/null || die
}

pkg_postinst() {
	elog
	elog " Check /usr/share/${PN}/holiday for examples to set your"
	elog " ~/.holiday according to your country."
	elog
	elog " WebPlan ${PV} can be found in /usr/share/${PN}/web."
	elog
}
