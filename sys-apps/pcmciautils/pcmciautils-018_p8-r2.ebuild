# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic linux-info toolchain-funcs udev

DEB_REV=${PV#*_p}
MY_PV=${PV%_p*}

DESCRIPTION="PCMCIA userspace utilities for Linux"
HOMEPAGE="https://packages.qa.debian.org/pcmciautils"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}-${DEB_REV}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc x86"
IUSE="debug staticsocket"

RDEPEND="virtual/modutils"
DEPEND="${RDEPEND}
	virtual/yacc
	sys-devel/flex"

S=${WORKDIR}/${PN}-${MY_PV}

pkg_setup() {
	CONFIG_CHECK="~PCMCIA"
	linux-info_pkg_setup

	kernel_is lt 2 6 32 && ewarn "${P} requires at least kernel 2.6.32."

	mypcmciaopts=(
		STARTUP=$(usex staticsocket false true)
		exec_prefix=/usr
		UDEV=true
		DEBUG=false
		STATIC=false
		V=true
		udevdir="$(get_udevdir)"
		CC="$(tc-getCC)"
		LD="$(tc-getCC)"
		AR="$(tc-getAR)"
		STRIP=true
		RANLIB="$(tc-getRANLIB)"
		OPTIMIZATION="${CFLAGS} ${CPPFLAGS}"
		DESTDIR="${D}"
		)

	use debug && append-cppflags -DDEBUG
}

PATCHES=(
	"${WORKDIR}"/debian/patches/no-modprobe-rules.patch
	"${WORKDIR}"/debian/patches/remove-libsysfs-dep.patch
	"${FILESDIR}"/${P}-flex-2.6.3-fix.patch
)

src_prepare() {
	default
	sed -i \
		-e '/CFLAGS/s:-fomit-frame-pointer::' \
		-e '/dir/s:sbin:bin:g' \
		Makefile || die
}

src_compile() {
	emake "${mypcmciaopts[@]}"
}

src_install() {
	emake "${mypcmciaopts[@]}" install

	dodoc doc/*.txt
}
