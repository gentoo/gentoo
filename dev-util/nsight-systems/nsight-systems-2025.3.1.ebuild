# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo unpacker

DESCRIPTION="performance analysis tool designed to visualize an application's algorithms"
HOMEPAGE="https://developer.nvidia.com/nsight-systems"

MY_PV="$(ver_rs 1-2 '_' "$(ver_cut 1-2)")"
MY_PN="${PN//nsight-}"
MY_PN_SHORT="sys"
PV_BUILD="90-1"

SRC_URI="
	amd64? (
		https://developer.nvidia.com/downloads/assets/tools/secure/${PN}/${MY_PV}/${PN}-${PV}_${PV}.${PV_BUILD}_amd64.deb
	)
	arm64? (
		https://developer.nvidia.com/downloads/assets/tools/secure/${PN}/${MY_PV}/${PN}-${PV}_${PV}.${PV_BUILD}_arm64.deb
	)
"

S="${WORKDIR}"

LICENSE="NVIDIA-r2"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm64"

RESTRICT="bindist mirror strip test"

RDEPEND="
	app-crypt/mit-krb5
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	dev-qt/qtwayland:6
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	media-libs/libglvnd
	media-libs/tiff-compat:4
	sys-apps/dbus
	sys-cluster/rdma-core
	x11-drivers/nvidia-drivers
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libxshmfence
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
	arm64? (
		media-libs/gst-plugins-bad:1.0
	)
"
BDEPEND="
	dev-util/patchelf
"

QA_PREBUILT="/opt/nvidia/${PN}/$(ver_cut 1-2)"

src_prepare() {
	if use amd64; then
		sed \
			-e "/Terminal/s/=No/=false/" \
			-e "/Categories/s/Application;//" \
			-i usr/share/applications/*.desktop || die

		if [[ -n "${EPREFIX}" ]]; then
			sed  -e "s#=/#=${EPREFIX}/#g" -i usr/share/applications/*.desktop || die
		fi
	fi

	local rpaths rpath
	readarray -t rpaths < <(
		find "${S}/opt/nvidia/${PN}/${PV}/host-linux-"* \
			-name 'libparquet*.so*.0.0' -o \
			-name 'libarrow*.so*.0.0' -o \
			-name 'libssh.so'|| die
	)
	for rpath in "${rpaths[@]}"; do
		edob -m "fixing rpath for ${rpath}" \
			patchelf --set-rpath '$ORIGIN' "${rpath}"
	done

	eapply_user
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	rm -r usr/local || die
	mv ./* "${ED}" || die

	# TODO install desktop file for arm64
}
