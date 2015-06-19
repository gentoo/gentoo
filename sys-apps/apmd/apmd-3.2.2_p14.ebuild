# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/apmd/apmd-3.2.2_p14.ebuild,v 1.7 2014/02/04 02:21:34 creffett Exp $

EAPI=5
inherit eutils multilib toolchain-funcs

MY_PV=${PV%_p*}
MY_P=${PN}_${MY_PV}
PATCHV=${PV#*_p}

DESCRIPTION="Advanced Power Management Daemon"
HOMEPAGE="http://packages.qa.debian.org/a/apmd.html"
SRC_URI="mirror://debian/pool/main/a/apmd/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/a/apmd/${MY_P}-${PATCHV}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE="nls X"

RDEPEND=">=sys-apps/debianutils-1.16
	>=sys-power/powermgmt-base-1.31
	X? ( x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXmu
		x11-libs/libSM
		x11-libs/libICE
		x11-libs/libXt
		x11-libs/libXext )"
DEPEND="${RDEPEND}
	sys-devel/libtool
	virtual/os-headers"

S=${WORKDIR}/${PN}-${MY_PV}.orig

src_prepare() {
	epatch "${WORKDIR}"/${MY_P}-${PATCHV}.diff

	if ! use X; then
		sed -i \
			-e 's:\(EXES=.*\)xapm:\1:' \
			-e 's:\(.*\)\$(LT_INSTALL).*xapm.*$:\1echo:' \
			Makefile || die
	fi

	# use system headers and skip on_ac_power
	rm -f on_ac_power*

	sed -i \
		-e '/on_ac_power/d' \
		-e 's:-I/usr/src/linux/include -I/usr/X11R6/include::' \
		-e 's:-L/usr/X11R6/lib::' \
		Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodir /usr/sbin
	emake DESTDIR="${D}" PREFIX=/usr LIBDIR=/usr/$(get_libdir) install

	keepdir /etc/apm/{event.d,suspend.d,resume.d,other.d,scripts.d}
	exeinto /etc/apm
	doexe debian/apmd_proxy
	dodoc AUTHORS {,apmsleep.}README debian/{changelog,README.Debian}

	doman *.{1,8}

	# note: apmd_proxy.conf is currently disabled and not used, thus
	# not installed - liquidx (01 Mar 2004)

	newconfd "${FILESDIR}"/apmd.confd apmd
	newinitd "${FILESDIR}"/apmd.rc6 apmd

	use nls || rm -rf "${D}"/usr/share/man/fr
}
