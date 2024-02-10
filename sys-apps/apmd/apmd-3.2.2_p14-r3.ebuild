# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV="${PV%_p*}"
MY_P="${PN}_${MY_PV}"
PATCHV="${PV#*_p}"

DESCRIPTION="Advanced Power Management Daemon"
HOMEPAGE="https://packages.qa.debian.org/a/apmd.html"
SRC_URI="mirror://debian/pool/main/a/apmd/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/a/apmd/${MY_P}-${PATCHV}.diff.gz"
S="${WORKDIR}/${PN}-${MY_PV}.orig"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE="nls X"

RDEPEND="
	>=sys-apps/debianutils-1.16
	>=sys-power/powermgmt-base-1.31
	X? (
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXmu
		x11-libs/libSM
		x11-libs/libICE
		x11-libs/libXt
		x11-libs/libXext
	)"
DEPEND="${RDEPEND}
	virtual/os-headers"

PATCHES=(
	"${WORKDIR}"/${MY_P}-${PATCHV}.diff
	"${FILESDIR}"/${PN}-${MY_PV}-libtool.patch # 778383
)

src_prepare() {
	default

	if ! use X; then
		sed -i \
			-e 's:\(EXES=.*\)xapm:\1:' \
			-e 's:\(.*\)\$(LT_INSTALL).*xapm.*$:\1echo:' \
			Makefile.in || die
	fi

	# use system headers and skip on_ac_power
	rm on_ac_power* || die

	sed -i \
		-e '/on_ac_power/d' \
		-e 's:-I/usr/src/linux/include -I/usr/X11R6/include::' \
		-e 's:-L/usr/X11R6/lib::' \
		Makefile.in || die

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install

	keepdir /etc/apm/{event.d,suspend.d,resume.d,other.d,scripts.d}
	exeinto /etc/apm
	doexe debian/apmd_proxy
	dodoc AUTHORS {,apmsleep.}README debian/{changelog,README.Debian}

	doman *.{1,8}

	# note: apmd_proxy.conf is currently disabled and not used, thus
	# not installed - liquidx (01 Mar 2004)

	newconfd "${FILESDIR}"/apmd.confd apmd
	newinitd "${FILESDIR}"/apmd.rc6 apmd

	if ! use nls; then
		rm -r "${ED}"/usr/share/man/fr || die
	fi

	find "${ED}" -name '*.la' -delete || die
}
