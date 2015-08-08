# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Allows to send commands to some microcontrollers, for example to change leds or sound a buzzer"
HOMEPAGE="http://qnap.nas-central.org/index.php/PIC_Control_Software"
SRC_URI="mirror://debian/pool/main/q/qcontrol/${P/-/_}.orig.tar.gz
	mirror://debian/pool/main/q/qcontrol/${P/-/_}-6.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm"
IUSE=""

DEPEND=">=dev-lang/lua-5.1"
RDEPEND="${DEPEND}"

src_unpack () {
	unpack ${A}
	cd "${WORKDIR}"

	epatch *.diff

	cd "${S}"
	epatch debian/patches/*.patch

	epatch "${FILESDIR}"/${PV}-Makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)" qcontrol || die "emake failed"
}

src_install() {
	dosbin qcontrol
	doman "${S}"/debian/qcontrol.1

	insinto /etc/qcontrol
	doins "${S}"/debian/configs/*.lua

	newconfd "${FILESDIR}"/conf.d qcontrol
	newinitd "${FILESDIR}"/init.d qcontrol
}

pkg_postinst() {
	device=$(grep "Hardware[[:space:]]*:" /proc/cpuinfo 2>/dev/null | \
		head -n1 | sed "s/^[^:]*: //")
	case $device in
		"QNAP TS-109/TS-209")
		dosym /etc/qcontrol/ts209.lua /etc/qcontrol.conf ;;
		"QNAP TS-119/TS-219")
		dosym /etc/qcontrol/ts219.lua /etc/qcontrol.conf ;;
		"QNAP TS-409")
		dosym /etc/qcontrol/ts409.lua /etc/qcontrol.conf ;;
		"QNAP TS-41x")
		dosym /etc/qcontrol/ts41x.lua /etc/qcontrol.conf ;;
		*)
		ewarn "Your device is unsupported" ;;
	esac
}
