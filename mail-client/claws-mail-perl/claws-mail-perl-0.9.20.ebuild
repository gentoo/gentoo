# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-perl/claws-mail-perl-0.9.20.ebuild,v 1.6 2013/05/08 04:02:05 fauli Exp $

MY_P="${PN#claws-mail-}_plugin-${PV}"

DESCRIPTION="Plugin to use perl to write filtering rules"
HOMEPAGE="http://www.claws-mail.org"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""
RDEPEND="~mail-client/claws-mail-3.9.0
		dev-lang/perl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf || die
	emake || die

	pod2man --section=1 --release=${PV} --name=cm_perl cm_perl.pod > cm_perl.1

	emake -C tools || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README

	doman cm_perl.1

	cd tools
	exeinto /usr/lib/claws-mail/tools
	doexe *.pl

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}

pkg_postinst() {
	echo
	elog "The documentation for this plugin is contained in a manpage."
	elog "You can access it with 'man cm_perl'"
	echo
}
