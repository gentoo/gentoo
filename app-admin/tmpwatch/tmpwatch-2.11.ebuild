# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Files which haven't been accessed in a given period of time are removed from specified directories"
HOMEPAGE="https://fedorahosted.org/tmpwatch/"
SRC_URI="https://fedorahosted.org/releases/t/m/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-tmpreaper )"
DEPEND=""

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	dosbin tmpwatch || die
	doman tmpwatch.8 || die
	dodoc ChangeLog NEWS README AUTHORS || die

	exeinto /etc/cron.daily
	newexe "${FILESDIR}/${PN}.cron" "${PN}" || die
}
