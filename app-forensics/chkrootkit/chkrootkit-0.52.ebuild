# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Tool to locally check for signs of a rootkit"
HOMEPAGE="http://www.chkrootkit.org/"
# Upstream named their *uncompressed* tarball .tar.gz (*sigh*)
SRC_URI="ftp://ftp.pangeia.com.br/pub/seg/pac/${P}.tar.gz -> ${P}.tar
	https://dev.gentoo.org/~polynomial-c/${PN}-0.51-gentoo.diff.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="+cron"

RDEPEND="cron? ( virtual/cron )"

PATCHES=(
	"${WORKDIR}"/${PN}-0.51-gentoo.diff
)

src_prepare() {
	default
	sed -e 's:/var/adm/:/var/log/:g' \
		-i chklastlog.c || die
}

src_compile() {
	emake CC="$(tc-getCC)" STRIP=true sense
}

src_install() {
	dosbin chkdirs chklastlog chkproc chkrootkit chkwtmp chkutmp ifpromisc strings-static
	dodoc ACKNOWLEDGMENTS README*

	if use cron ; then
		exeinto /etc/cron.weekly
		newexe "${FILESDIR}"/${PN}.cron ${PN}
	fi
}

pkg_postinst() {
	if use cron ; then
		elog
		elog "Edit /etc/cron.weekly/chkrootkit to activate chkrootkit!"
		elog
	fi

	elog
	elog "Some applications, such as portsentry, will cause chkrootkit"
	elog "to produce false positives.  Read the chkrootkit FAQ at"
	elog "http://www.chkrootkit.org/ for more information."
	elog
}
