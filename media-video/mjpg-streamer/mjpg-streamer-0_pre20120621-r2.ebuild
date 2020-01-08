# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="MJPG-streamer takes JPGs from Linux-UVC compatible webcams"
HOMEPAGE="https://sourceforge.net/projects/mjpg-streamer"
SRC_URI="https://dev.gentoo.org/~aidecoe/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

INPUT_PLUGINS="input-testpicture input-control input-file input-uvc"
OUTPUT_PLUGINS="output-file output-udp output-http output-autofocus output-rtsp"
IUSE_PLUGINS="${INPUT_PLUGINS} ${OUTPUT_PLUGINS}"
IUSE="input-testpicture input-control +input-file input-uvc output-file
	output-udp +output-http output-autofocus output-rtsp
	www"
REQUIRED_USE="|| ( ${INPUT_PLUGINS} )
	|| ( ${OUTPUT_PLUGINS} )"

RDEPEND="virtual/jpeg
	input-uvc? ( media-libs/libv4l )"
DEPEND="${RDEPEND}
	input-testpicture? ( media-gfx/imagemagick )"

PATCHES=(
	"${FILESDIR}/make-var-instead-of-cmd.patch"
	"${FILESDIR}/to-work-with-kernel-3.18.patch"
)

src_prepare() {
	default

	local flag switch

	for flag in ${IUSE_PLUGINS}; do
		use ${flag} && switch='' || switch='#'
		flag=${flag/input-/input_}
		flag=${flag/output-/output_}
		sed -i \
			-e "s|^#*PLUGINS +\?= ${flag}.so|${switch}PLUGINS += ${flag}.so|" \
			Makefile
	done
}

src_compile() {
	local v4l=$(use input-uvc && echo 'USE_LIBV4L2=true')
	emake ${v4l}
}

src_install() {
	into /usr
	dobin ${PN//-/_}
	dolib.so *.so

	if use www ; then
		insinto /usr/share/${PN}
		doins -r www
	fi

	dodoc README TODO

	sed -e "s|@LIBDIR@|$(get_libdir)|g" "${FILESDIR}/${PN}.initd" | newinitd - ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

pkg_postinst() {
	elog "Remember to set an input and output plugin for mjpg-streamer."

	if use www ; then
		echo
		elog "An example webinterface has been installed into"
		elog "/usr/share/mjpg-streamer/www for your usage."
	fi
}
