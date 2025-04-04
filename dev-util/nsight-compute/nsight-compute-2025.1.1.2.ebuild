# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker

DESCRIPTION="performance analysis tool designed to visualize an application’s algorithms"
HOMEPAGE="https://developer.nvidia.com/nsight-systems"

MY_PV=$(ver_cut 1-3)
MY_PV=${MY_PV//./_}

PV_BUILD="35528883"
SRC_URI="
	amd64? (
		https://developer.nvidia.com/downloads/assets/tools/secure/${PN}/${MY_PV}/${PN}-linux-${PV}-${PV_BUILD}.run
	)
	arm64? (
		https://developer.nvidia.com/downloads/assets/tools/secure/${PN}/${MY_PV}/${PN}-armserver-${PV}-${PV_BUILD}.run
	)
	mirror+https://developer.download.nvidia.com/images/nvidia-nsight-compute-icon-gbp-shaded-128.png
		-> nvidia-nsight-compute-icon-gbp-shaded-128.20231126.png
"
S="${WORKDIR}/pkg"

LICENSE="NVIDIA-r2"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm64"

RESTRICT="bindist mirror strip test"

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	dev-qt/qtdeclarative:6
	dev-qt/qtpositioning:6
	dev-qt/qtwayland:6
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6
	media-libs/fontconfig
	media-libs/libglvnd
	media-libs/tiff-compat:4
	sys-apps/dbus
	sys-cluster/rdma-core
	x11-drivers/nvidia-drivers
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libdrm
	x11-libs/libxcb:=
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libxshmfence
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
"
BDEPEND="
	dev-util/patchelf
"

QA_PREBUILT="/opt/nvidia/${PN}/$(ver_cut 1-2)"

src_prepare() {
	if [[ -n "${EPREFIX}" ]]; then
		sed  -e "s#=/#=${EPREFIX}/#g" -i usr/share/applications/*.desktop || die
	fi

	pushd host/linux-desktop-* >/dev/null || die

	readarray -t rpath_bins < <(find . -maxdepth 1 -name '*.bin')
	for rpath_bin in "${rpath_bins[@]}"; do
		ebegin "fixing rpath for ${rpath_bin}"
		patchelf --set-rpath '$ORIGIN' "${rpath_bin}" || die
		eend $?

		# OpenGLVersionChecker stumbles on "OpenGL ES profile version string" so disable the check
		sed \
			-e "s/NV_AGORA_PATH/NV_AGORA_PATH_/g" \
			-e "4i export QT_PLUGIN_PATH=\"\${NV_AGORA_PATH_}/Plugins\"" \
			-e "s/AGORA_USE_MESA_FALLBACK=true/AGORA_USE_MESA_FALLBACK=false/" \
			-i "$(basename "${rpath_bin}" .bin)" \
			|| die
	done

	popd &>/dev/null || die

	eapply_user
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	local dir
	dir="/opt/nvidia/${PN}/$(ver_cut 1-2)"

	dodir "${dir}"
	mv ./* "${ED}${dir}" || die

	local arch_dir="$(find "${ED}${dir}/host" -mindepth 1 -maxdepth 1 -name 'linux-*' -exec basename {} \;)"
	if [[ -z "${arch_dir}" ]]; then
		die "failed to find arch dir"
	fi
	if [[ "$(echo "${arch_dir}" | wc -l )" -gt 1 ]]; then
		echo ${arch_dir}
		die "found $(echo "${arch_dir}" | wc -l )"
	fi

	cp \
		"${DISTDIR}/nvidia-nsight-compute-icon-gbp-shaded-128.20231126.png" \
		"${ED}${dir}/host/${arch_dir}/ncu-ui.png" \
			|| die

	newmenu - "${P}.desktop" <<-EOF || die
		[Desktop Entry]
		Type=Application
		Name=NVIDIA Nsight Compute ${PV}
		GenericName=NVIDIA Nsight Compute
		Icon=${EPREFIX}${dir}/host/${arch_dir}/ncu-ui.png
		Exec=env WAYLAND_DISPLAY= ${EPREFIX}${dir}/host/${arch_dir}/ncu-ui
		TryExec=${EPREFIX}${dir}/host/${arch_dir}/ncu-ui
		Keywords=cuda;gpu;nvidia;nsight;
		X-AppInstall-Keywords=cuda;gpu;nvidia;nsight;
		X-GNOME-Keywords=cuda;gpu;nvidia;nsight;
		Terminal=false
		Categories=Development;Profiling;ParallelComputing
	EOF
}
