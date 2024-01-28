# Copyright 2011-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit chromium-2 desktop pax-utils unpacker xdg

DESCRIPTION="The web browser from Microsoft"
HOMEPAGE="https://www.microsoft.com/en-us/edge"

if [[ ${PN} == microsoft-edge ]]; then
	MY_PN=${PN}-stable
else
	MY_PN=${PN}
fi

KEYWORDS="-* ~amd64"

MY_P="${MY_PN}_${PV}-1"

SRC_URI="https://packages.microsoft.com/repos/edge/pool/main/m/${MY_PN}/${MY_P}_amd64.deb"

LICENSE="microsoft-edge"
SLOT="0"
RESTRICT="bindist mirror strip"
IUSE="+mip qt5 qt6"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-fonts/liberation-fonts
	media-libs/alsa-lib
	media-libs/mesa[gbm(+)]
	net-misc/curl[ssl]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	x11-misc/xdg-utils
	mip? ( app-crypt/libsecret )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[X]
		dev-qt/qtwidgets:5
	)
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
"

QA_PREBUILT="*"
QA_DESKTOP_FILE="usr/share/applications/microsoft-edge.*\\.desktop"
S=${WORKDIR}
EDGE_HOME="opt/microsoft/msedge${PN#microsoft-edge}"

pkg_nofetch() {
	eerror "Please wait 24 hours and sync your tree before reporting a bug for microsoft-edge fetch failures."
}

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "microsoft-edge only works on amd64"
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker

	rm -f _gpgorigin || die

	rm -r etc usr/share/menu || die
	mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die

	gzip -d usr/share/doc/${PF}/changelog.gz || die
	gzip -d usr/share/man/man1/${MY_PN}.1.gz || die
	if [[ -L usr/share/man/man1/${PN}.1.gz ]]; then
		rm usr/share/man/man1/${PN}.1.gz || die
		dosym ${MY_PN}.1 usr/share/man/man1/${PN}.1
	fi

	local suffix=
	[[ ${PN} == microsoft-edge-beta ]] && suffix=_beta
	[[ ${PN} == microsoft-edge-dev ]] && suffix=_dev

	local size
	for size in 16 24 32 48 64 128 256 ; do
		newicon -s ${size} "${EDGE_HOME}/product_logo_${size}${suffix}.png" ${PN}.png
	done

	if ! use mip; then
		rm "${EDGE_HOME}"/libmip_{core,protection_sdk}.so || die
	fi

	if ! use qt5; then
		rm "${EDGE_HOME}/libqt5_shim.so" || die
	fi
	if ! use qt6; then
		rm "${EDGE_HOME}/libqt6_shim.so" || die
	fi

	pax-mark m "${EDGE_HOME}/msedge"
}
