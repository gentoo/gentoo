# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/metalog/metalog-2.ebuild,v 1.10 2012/07/15 22:21:32 vapier Exp $

EAPI="3"

inherit eutils

DESCRIPTION="A highly configurable replacement for syslogd/klogd"
HOMEPAGE="http://metalog.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="unicode"

RDEPEND=">=dev-libs/libpcre-3.4"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9-metalog-conf.patch
	epatch "${FILESDIR}"/${P}-no-gets.patch #426632
}

src_configure() {
	econf $(use_with unicode)
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README NEWS metalog.conf

	into /
	dosbin "${FILESDIR}"/consolelog.sh || die

	newinitd "${FILESDIR}"/metalog.initd metalog
	newconfd "${FILESDIR}"/metalog.confd metalog
}

pkg_preinst() {
	if [[ -d "${ROOT}"/etc/metalog ]] && [[ ! -e "${ROOT}"/etc/metalog.conf ]] ; then
		mv -f "${ROOT}"/etc/metalog/metalog.conf "${ROOT}"/etc/metalog.conf
		rmdir "${ROOT}"/etc/metalog
		export MOVED_METALOG_CONF=true
	else
		export MOVED_METALOG_CONF=false
	fi
}

pkg_postinst() {
	if ${MOVED_METALOG_CONF} ; then
		ewarn "The default metalog.conf file has been moved"
		ewarn "from /etc/metalog/metalog.conf to just"
		ewarn "/etc/metalog.conf.  If you had a standard"
		ewarn "setup, the file has been moved for you."
	fi
}
