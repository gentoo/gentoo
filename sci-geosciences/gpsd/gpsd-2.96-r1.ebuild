# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gpsd/gpsd-2.96-r1.ebuild,v 1.7 2014/08/10 20:27:43 slyfox Exp $

EAPI=3

PYTHON_DEPEND="2:2.6"

inherit python autotools user eutils

DESCRIPTION="GPS daemon and library to support USB/serial GPS devices and various GPS/mapping clients"
HOMEPAGE="http://gpsd.berlios.de/"
SRC_URI="mirror://berlios/gpsd/${P}bis.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

GPSD_PROTOCOLS="ashtech aivdm clientdebug earthmate evermore fv18 garmin
	garmintxt gpsclock itrax mtk3301 nmea ntrip navcom oceanserver
	oldstyle oncore rtcm104v2 rtcm104v3 sirf superstar2 timing tsip
	tripmate tnt ubx"
for protocol in ${GPSD_PROTOCOLS}; do
	IUSE_GPSD_PROTOCOLS+=" gpsd_protocols_${protocol}"
done

IUSE="${IUSE_GPSD_PROTOCOLS} dbus ipv6 ntp qt4 test udev"

# those harddeps are de-facto automagicall
RDEPEND="
	dev-python/pygtk:2
	sys-libs/ncurses
	virtual/libusb:1
	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib
	)
	ntp? ( net-misc/ntp )
	qt4? ( dev-qt/qtgui:4 )"

DEPEND="${RDEPEND}
	app-text/xmlto
	=app-text/docbook-xml-dtd-4.1*
	test? ( sys-devel/bc )"

PATCHES=(
	"${FILESDIR}/2.95-disable-strip.patch"
	"${FILESDIR}/${PV}-fix-ldflags.patch"
	"${FILESDIR}/${PV}-fix-tests.patch"
	"${FILESDIR}/${PV}-pkgconfig.patch"
)

pkg_setup() {
	python_set_active_version 2

	# Run the gpsd daemon as gpsd and group uucp
	enewuser gpsd -1 -1 -1 "uucp"
}

src_prepare() {
	epatch ${PATCHES[@]}
	epatch_user
	eautoreconf
}

src_configure() {
	local myopts

	# enable specified protocols
	for protocol in ${GPSD_PROTOCOLS}; do
		myopts+=" $(use_enable gpsd_protocols_${protocol} ${protocol})"
	done

	if ! use qt4 ; then
		myopts+=" --disable-libQgpsmm --disable-libgpsmm"
	fi

	# --disable-bluetooth: considered experimental -> disable
	# Hack to make it not generate docs on the fly; xmlto is
	# needed for man pages (xsltproc is only needed for web pages)
	WITH_XMLTO=yes WITH_XSLTPROC=no econf \
		--disable-dependency-tracking \
		--disable-bluetooth \
		--disable-static \
		--enable-gpsd-user=gpsd \
		--enable-gpsd-group=uucp \
		$(use_enable dbus) \
		$(use_enable ipv6) \
		$(use_enable ntp ntpshm) \
		$(use_enable ntp pps) \
		${myopts}
}

src_install() {
	# no it can't be done using emake cause it is non-compliant
	make DESTDIR="${D}" install || die

	if use udev ; then
		insinto /lib/udev/rules.d/
		newins gpsd.rules 25-gpsd.rules
		exeinto /lib/udev/
		doexe gpsd.hotplug{,.wrapper}
	fi

	# needs this header for libQgpsmm
	if use qt4 ; then
		insinto /usr/include
		doins libQgpsmm/libQgpsmm_global.h
	fi

	# no need for .la files here
	find "${D}" -type f -name '*.la' -exec rm -f '{}' +

	newconfd "${FILESDIR}"/gpsd.conf-2 gpsd || die
	newinitd "${FILESDIR}"/gpsd.init-2 gpsd || die
}
