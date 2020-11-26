# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="User level application for IBM Mwave modem"
HOMEPAGE="http://oss.software.ibm.com/acpmodem/"
SRC_URI="ftp://www-126.ibm.com/pub/acpmodem/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-glibc-2.10.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-ar.patch
)

HTML_DOCS=( doc/mwave.html )

src_prepare() {
	default
	rm README.freebsd || die
	mv configure.{in,ac} || die
	AT_M4DIR=m4 eautoreconf
}

src_install() {
	default

	dosbin "${FILESDIR}"/mwave-dev-handler

	insinto /etc/devfs.d
	newins "${FILESDIR}"/mwave.devfs mwave

	insinto /etc/modprobe.d
	newins "${FILESDIR}"/mwave.modules mwave.conf

	dodoc doc/mwave.sgml doc/mwave.txt
}

pkg_postinst() {
	if [[ -e "${EROOT}"/dev/.devfsd ]]; then
		# device node is created by devfs
		ebegin "Restarting devfsd to reread devfs rules"
			killall -HUP devfsd
		eend $?
	else
		elog "Create device node if needed, using command like this:"
		elog "# mknod --mode=0660 \"${EROOT}/dev/modems/mwave\" c 10 219"
	fi
}
