# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/liquid_feedback_core/liquid_feedback_core-2.2.6.ebuild,v 1.3 2014/12/30 11:06:24 tupone Exp $

EAPI=5

inherit eutils toolchain-funcs

MY_P=${PN}-v${PV}

DESCRIPTION="Internet platforms for proposition development and decision making"
HOMEPAGE="http://www.public-software-group.org/liquid_feedback"
SRC_URI="http://www.public-software-group.org/pub/projects/liquid_feedback/backend/v${PV}/${MY_P}.tar.gz"

LICENSE="HPND CC-BY-2.5"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-db/postgresql"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="-I $(pg_config --includedir)" \
		LDFLAGS="${LDFLAGS} -L $(pg_config --libdir)"
}

src_install() {
	dobin lf_update lf_update_suggestion_order lf_export
	insinto /usr/share/${PN}
	doins -r {core,init,demo,test}.sql update
	dodoc README "${FILESDIR}"/postinstall-en.txt
}

pkg_postinst() {
	elog "If you just upgraded, remember to update database schema"
	elog "with the scripts in /usr/share/${PN}/update"
}
