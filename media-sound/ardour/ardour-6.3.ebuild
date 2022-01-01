# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7,8,9} )
PYTHON_REQ_USE='threads(+)'
PLOCALES="cs de el en_GB es eu fr it ja nn pl pt pt_PT ru sv zh"
inherit eutils toolchain-funcs flag-o-matic l10n python-any-r1 waf-utils

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="https://ardour.org/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.ardour.org/ardour/ardour.git"
	inherit git-r3
else
	KEYWORDS="~amd64 x86"
	SRC_URI="https://dev.gentoo.org/~fordfrog/distfiles/Ardour-${PV}.0.tar.bz2"
	S="${WORKDIR}/Ardour-${PV}.0"
fi

LICENSE="GPL-2"
SLOT="6"
IUSE="altivec doc jack nls phonehome pulseaudio cpu_flags_x86_sse cpu_flags_x86_mmx cpu_flags_x86_3dnow"

RDEPEND="
	>=dev-cpp/glibmm-2.32.0
	>=dev-cpp/gtkmm-2.16:2.4
	>=dev-cpp/libgnomecanvasmm-2.26:2.6
	dev-libs/boost:=
	>=dev-libs/glib-2.10.1:2
	dev-libs/libsigc++:2
	>=dev-libs/libxml2-2.6:2
	dev-libs/libxslt
	>=gnome-base/libgnomecanvas-2
	media-libs/alsa-lib
	media-libs/aubio
	media-libs/flac
	media-libs/freetype:2
	media-libs/libart_lgpl
	media-libs/liblo
	>=media-libs/liblrdf-0.4.0-r20
	>=media-libs/libsamplerate-0.1
	>=media-libs/libsndfile-1.0.18
	>=media-libs/libsoundtouch-1.6.0
	media-libs/raptor:2
	>=media-libs/rubberband-1.6.0
	>=media-libs/taglib-1.7
	media-libs/vamp-plugin-sdk
	net-misc/curl
	sys-libs/readline:0=
	sci-libs/fftw:3.0[threads]
	virtual/libusb:1
	x11-libs/cairo
	>=x11-libs/gtk+-2.8.1:2
	x11-libs/pango
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
	media-libs/lilv
	media-libs/sratom
	dev-libs/sord
	>=media-libs/suil-0.6.10
	>=media-libs/lv2-1.4.0"
#	!bundled-libs? ( media-sound/fluidsynth ) at leat libltc is missing to be able to unbundle...

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	jack? ( virtual/jack )
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

pkg_pretend() {
	[[ $(tc-getLD) == *gold* ]] && (has_version sci-libs/fftw[openmp] || has_version sci-libs/fftw[threads]) && \
		ewarn "Linking with gold linker might produce broken executable, see bug #733972"
}

pkg_setup() {
	if has_version \>=dev-libs/libsigc++-2.6 ; then
		append-cxxflags -std=c++11
	fi
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	sed 's/'full-optimization\'\ :\ \\[.*'/'full-optimization\'\ :\ \'\','/' -i "${S}"/wscript || die
	MARCH=$(get-flag march)
	OPTFLAGS=""
	if use cpu_flags_x86_sse; then
		if [[ ${MARCH} == "i686" ]] || [[ ${MARCH} == "i486" ]]; then
			elog "You enabled sse but use an march that does not support sse!"
			elog "We add -msse to the flags now, but please consider switching your march in make.conf!"
		fi
		OPTFLAGS="sse"
	fi
	if use cpu_flags_x86_mmx; then
		if [[ ${MARCH} == "i486" ]]; then
		    elog "You enabled mmx with i486 set as march! You have been warned!"
		fi
		OPTFLAGS="${OPTFLAGS} mmx"
	fi
	if use cpu_flags_x86_3dnow; then
		OPTFLAGS="${OPTFLAGS} 3dnow"
	fi
	sed 's/flag_line\ =\ o.*/flag_line\ =\ \": '"${OPTFLAGS}"' just some place holders\"/' \
		-i "${S}"/wscript || die
	sed 's/cpu\ ==\ .*/cpu\ ==\ "LeaveMarchAsIs":/' -i "${S}"/wscript || die
	append-flags "-lboost_system"
	python_fix_shebang "${S}"/wscript
	python_fix_shebang "${S}"/waf
	my_lcmsg() {
		rm -f {gtk2_ardour,gtk2_ardour/appdata,libs/ardour,libs/gtkmm2ext}/po/${1}.po
	}
	l10n_for_each_disabled_locale_do my_lcmsg
}

src_configure() {
	local backends="alsa"
	use jack && backends+=",jack"
	use pulseaudio && backends+=",pulseaudio"

	tc-export CC CXX
	mkdir -p "${D}"
	waf-utils_src_configure \
		--destdir="${D}" \
		--configdir=/etc \
		--optimize \
		--with-backends=${backends} \
		$(usex doc "--docs" '') \
		$({ use altivec || use cpu_flags_x86_sse; } && echo "--fpu-optimization" || echo "--no-fpu-optimization") \
		$(usex phonehome "--phone-home" "--no-phone-home") \
		$(usex nls "--nls" "--no-nls")
#not possible right now		--use-external-libs
}
src_compile() {
	waf-utils_src_compile
	use nls && waf-utils_src_compile i18n
}
src_install() {
	waf-utils_src_install
	mv ${PN}.1 ${PN}${SLOT}.1
	doman ${PN}${SLOT}.1
	newicon "${S}/gtk2_ardour/resources/Ardour-icon_48px.png" ${PN}${SLOT}.png
	make_desktop_entry ardour6 ardour6 ardour6 AudioVideo
}

pkg_postinst() {
	elog "Please do _not_ report problems with the package to ${PN} upstream."
	elog "If you think you've found a bug, check the upstream binary package"
	elog "before you report anything to upstream."
}
