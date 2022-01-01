# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 luajit )

inherit lua-single toolchain-funcs

DESCRIPTION="Send commands to some microcontrollers, e.g., to change LEDs or sound a buzzer"
HOMEPAGE="http://qnap.nas-central.org/index.php/PIC_Control_Software"
SRC_URI="mirror://debian/pool/main/q/qcontrol/${P/-/_}.orig.tar.gz
	mirror://debian/pool/main/q/qcontrol/${P/-/_}-6.diff.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eapply "${WORKDIR}"/*.diff
	eapply debian/patches/*.patch
	eapply "${FILESDIR}"/${PV}-Makefile.patch

	sed -i -e "s/LDFLAGS=/LDFLAGS ?=/" Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="$(lua_get_CFLAGS) ${CFLAGS}" \
		LDFLAGS="$(lua_get_LIBS) -lpthread ${LDFLAGS}" \
		qcontrol
}

src_install() {
	dosbin qcontrol
	doman debian/qcontrol.1

	insinto /etc/qcontrol
	doins debian/configs/*.lua

	newconfd "${FILESDIR}"/conf.d qcontrol
	newinitd "${FILESDIR}"/init.d qcontrol
}

pkg_preinst() {
	device=$(grep "Hardware[[:space:]]*:" /proc/cpuinfo 2>/dev/null | \
		head -n1 | sed "s/^[^:]*: //")
	case ${device} in
		"QNAP TS-109/TS-209")
		dosym qcontrol/ts209.lua /etc/qcontrol.conf ;;
		"QNAP TS-119/TS-219")
		dosym qcontrol/ts219.lua /etc/qcontrol.conf ;;
		"QNAP TS-409")
		dosym qcontrol/ts409.lua /etc/qcontrol.conf ;;
		"QNAP TS-41x")
		dosym qcontrol/ts41x.lua /etc/qcontrol.conf ;;
		*)
		ewarn "Your device is unsupported" ;;
	esac
}
