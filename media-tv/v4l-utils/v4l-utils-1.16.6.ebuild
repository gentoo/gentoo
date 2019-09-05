# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic udev xdg-utils

DESCRIPTION="Separate utilities ebuild from upstream v4l-utils package"
HOMEPAGE="https://git.linuxtv.org/v4l-utils.git"
SRC_URI="https://linuxtv.org/downloads/v4l-utils/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc64 ~sparc x86"
IUSE="+bpf opengl qt5"

RDEPEND=">=media-libs/libv4l-${PV}[jpeg]
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		opengl? ( dev-qt/qtopengl:5[-gles2(-)] virtual/opengl )
		media-libs/alsa-lib
	)
	virtual/libudev
	>=virtual/jpeg-0-r2:0=
	bpf? ( virtual/libelf:= )
	!media-tv/v4l2-ctl
	!<media-tv/ivtv-utils-1.4.0-r2"
DEPEND="${RDEPEND}"
BDEPEND="
	bpf? ( sys-devel/clang:*[llvm_targets_BPF] )
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	if use qt5; then
		append-cxxflags -std=c++11
		local qt5_paths=( \
			MOC="$(pkg-config --variable=host_bins Qt5Core)/moc" \
			UIC="$(pkg-config --variable=host_bins Qt5Core)/uic" \
			RCC="$(pkg-config --variable=host_bins Qt5Core)/rcc" \
		)
		if use !opengl; then
			sed -e 's/Qt5OpenGL/DiSaBlEd/g' -i configure || die
		fi
	fi
	# Hard disable the flags that apply only to the libs.
	econf \
		--disable-static \
		$(use_enable qt5 qv4l2) \
		$(use_enable qt5 qvidcap) \
		$(use_enable bpf) \
		--with-udevdir="$(get_udevdir)" \
		--with-jpeg \
		"${qt5_paths[@]}"
}

src_install() {
	emake -C utils DESTDIR="${D}" install
	emake -C contrib DESTDIR="${D}" install

	dodoc README
	newdoc utils/libv4l2util/TODO TODO.libv4l2util
	newdoc utils/libmedia_dev/README README.libmedia_dev
	newdoc utils/dvb/README README.dvb
	newdoc utils/v4l2-compliance/fixme.txt fixme.txt.v4l2-compliance
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
