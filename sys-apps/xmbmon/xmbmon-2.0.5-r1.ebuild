# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${PN}${PV//.}

DESCRIPTION="Mother Board Monitor Program for X Window System"
HOMEPAGE="http://www.nt.phys.kyushu-u.ac.jp/shimizu/download/download.html"
SRC_URI="http://www.nt.phys.kyushu-u.ac.jp/shimizu/download/xmbmon/${MY_P}.tar.gz"
#	http://www.nt.phys.kyushu-u.ac.jp/shimizu/download/xmbmon/${MY_P}_A7N8X-VM.patch

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X"

RDEPEND="
	X? (
		x11-libs/libXt
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libICE
	)"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}
PATCHES=(
	# "${DISTDIR}"/${MY_P}_A7N8X-VM.patch
	"${FILESDIR}"/${P}-fflush.patch
	"${FILESDIR}"/${P}-amd64.patch
	"${FILESDIR}"/${P}-pid.patch
	"${FILESDIR}"/${P}-loopback.patch
)

src_prepare() {
	default

	sed -i \
		-e "/^CFLAGS=/s/-O3/${CFLAGS}/" \
		-e '/^LDFLAGS=-s$/d' \
		Makefile.in || die
	sed -i \
		-e '/^[[:space:]]*CC=gcc/s,.*,:;,' \
		configure || die
}

src_compile() {
	emake mbmon
	use X && emake xmbmon
}

src_install() {
	dosbin mbmon
	doman mbmon.1
	dodoc ChangeLog* ReadMe* mbmon-rrd.pl

	if use X; then
		dosbin xmbmon
		doman xmbmon.1x

		insinto /etc/X11/app-defaults/
		newins xmbmon.resources XMBmon
	fi

	newinitd "${FILESDIR}"/mbmon.rc mbmon
	newconfd "${FILESDIR}"/mbmon.confd mbmon
}

pkg_postinst() {
	einfo "These programs access SMBus/ISA-IO ports without any kind"
	einfo "of checking.  It is, therefore, very dangerous and may cause"
	einfo "a system-crash. Make sure you read ReadMe,"
	einfo "section 4, 'How to use!'"
}
