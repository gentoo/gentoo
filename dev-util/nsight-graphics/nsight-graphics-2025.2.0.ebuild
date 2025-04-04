# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker

DESCRIPTION="standalone developer tool with ray-tracing support"
HOMEPAGE="https://developer.nvidia.com/nsight-graphics"

MY_PV="$(ver_rs 1-3 '_')"
PV_BUILD="25073"

SRC_URI="
	https://developer.nvidia.com/downloads/assets/tools/secure/${PN}/${MY_PV}/linux/NVIDIA_Nsight_Graphics_${PV}.${PV_BUILD}.run
	mirror+https://developer.download.nvidia.com/images/nvidia-nsight-graphics-icon-gbp-shaded-128.png
		-> nvidia-nsight-graphics-icon-gbp-shaded-128.20231126.png
"

S="${WORKDIR}/pkg"

LICENSE="NVIDIA-r2"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"

RESTRICT="bindist mirror strip test"

RDEPEND="
	dev-libs/glib:2
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
	sys-apps/util-linux
	x11-drivers/nvidia-drivers
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libxkbcommon
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
	rm EULA.txt || die

	pushd host/linux-desktop-nomad-* >/dev/null || die

	readarray -t rpath_bins < <(find . -maxdepth 1 -name '*.bin')
	for rpath_bin in "${rpath_bins[@]}"; do
		ebegin "fixing rpath for ${rpath_bin}"
		patchelf --set-rpath '$ORIGIN' "${rpath_bin}" || die
		eend $?

		sed \
			-e "s/NV_AGORA_PATH/NV_AGORA_PATH_/g" \
			-e "4i export QT_PLUGIN_PATH=\"\${NV_AGORA_PATH_}/Plugins\"" \
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
		"${DISTDIR}/nvidia-nsight-graphics-icon-gbp-shaded-128.20231126.png" \
		"${ED}${dir}/host/${arch_dir}/ngfx-ui.png" \
			|| die

	newmenu - "${P}.desktop" <<-EOF || die
		[Desktop Entry]
		Type=Application
		Name=NVIDIA Nsight Graphics ${PV}
		GenericName=NVIDIA Nsight Graphics
		Icon=${EPREFIX}${dir}/host/${arch_dir}/ngfx-ui.png
		Exec=env WAYLAND_DISPLAY= ${EPREFIX}${dir}/host/${arch_dir}/ngfx-ui
		TryExec=${EPREFIX}${dir}/host/${arch_dir}/ngfx-ui
		Keywords=cuda;gpu;nvidia;nsight;
		X-AppInstall-Keywords=cuda;gpu;nvidia;nsight;
		X-GNOME-Keywords=cuda;gpu;nvidia;nsight;
		Terminal=false
		Categories=Development;Profiling;ParallelComputing
	EOF
}
