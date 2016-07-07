# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs eutils

DESCRIPTION="Files which haven't been accessed in a given period of time are removed from specified directories"
HOMEPAGE="https://fedorahosted.org/tmpwatch/"
SRC_URI="https://fedorahosted.org/releases/t/m/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-tmpreaper )"
DEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-boottime.patch"
)

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	dosbin tmpwatch
	doman tmpwatch.8

	exeinto /etc/cron.daily
	newexe "${FILESDIR}/${PN}.cron" "${PN}"
}
