# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer-meson

DESCRIPTION="OpenCV elements for GStreamer"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND=">=media-libs/opencv-4.1.2-r3:=[contrib,contribdnn,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

multilib_src_install() {
	gstreamer_multilib_src_install

	# Handhold install of libgstopencv.so outside of gst-plugins-bad
	for file in gst-libs/gst/opencv/* ; do
		if [[ -f ${file} ]] && ! [[ -d ${file} ]] && ! [[ -h ${file} ]]; then
			# libgstopencv-1.0.so.0.2413.0 -> libgstopencv-1.0.so.0 -> libgstopencv-1.0.so
			dolib.so "${file}"
			file_name="${file##*\/}"
			dosym "${file_name}" "${EPREFIX}/usr/$(get_libdir)/${file_name%.*.*}"
			dosym "${file_name%.*.*}" "${EPREFIX}/usr/$(get_libdir)/${file_name%.*.*.*}"
		fi
	done
	insinto /usr/include/gstreamer-${SLOT}/gst/opencv/
	doins "${S}"/gst-libs/gst/opencv/*.h
}
