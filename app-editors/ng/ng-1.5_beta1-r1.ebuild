# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/ng/ng-1.5_beta1-r1.ebuild,v 1.4 2014/07/08 00:46:30 naota Exp $

EAPI=5

inherit eutils autotools

MY_P="${P/_beta/beta}"

DESCRIPTION="Emacs like micro editor Ng -- based on mg2a"
HOMEPAGE="http://tt.sakura.ne.jp/~amura/ng/"
SRC_URI="http://tt.sakura.ne.jp/~amura/archives/ng/${MY_P}.tar.gz"

LICENSE="Emacs"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="canna"

RDEPEND=">=sys-libs/ncurses-5.0
	!dev-java/nailgun
	canna? ( app-i18n/canna )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4.0"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${MY_P}-ncurses.patch"
	epatch "${FILESDIR}/${MY_P}-configure.patch"
	sed -i -e "/NO_BACKUP/s/undef/define/" config.h || die "sed failed"

	pushd sys/unix || die
	eautoconf
	popd
	cp sys/unix/configure . || die
}

src_configure() {
	econf $(use_enable canna)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ng
	dodoc docs/* MANIFEST dot.ng

	insinto /usr/share/ng
	doins bin/*

	insinto /etc/skel
	newins dot.ng .ng
}

pkg_postinst() {
	elog
	elog "If you want to use user Config"
	elog "cp /etc/skel/.ng ~/.ng"
	elog "and edit your .ng configuration file."
	elog
}
