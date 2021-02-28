# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='threads(+)'
PLOCALES="cs de el en_GB es eu fr it ja nn pl pt pt_PT ru sv zh"
inherit eutils toolchain-funcs flag-o-matic l10n python-any-r1 waf-utils desktop xdg

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="https://ardour.org/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.ardour.org/ardour/ardour.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://dev.gentoo.org/~fordfrog/distfiles/Ardour-${PV}.0.tar.bz2"
	S="${WORKDIR}/Ardour-${PV}.0"
fi

LICENSE="GPL-2"
SLOT="6"
IUSE="altivec doc jack nls phonehome pulseaudio cpu_flags_x86_sse cpu_flags_x86_mmx cpu_flags_x86_3dnow"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-cpp/libgnomecanvasmm:2.6
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/libsigc++:2
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=gnome-base/libgnomecanvas-2
	media-libs/alsa-lib
	media-libs/aubio
	media-libs/flac
	media-libs/freetype:2
	media-libs/libart_lgpl
	media-libs/liblo
	media-libs/liblrdf
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/libsoundtouch
	media-libs/raptor:2
	media-libs/rubberband
	media-libs/taglib
	media-libs/vamp-plugin-sdk
	net-misc/curl
	sys-libs/readline:0=
	sci-libs/fftw:3.0[threads]
	virtual/libusb:1
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/pango
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
	media-libs/lilv
	media-libs/sratom
	dev-libs/sord
	media-libs/suil
	media-libs/lv2"
#	!bundled-libs? ( media-sound/fluidsynth ) at least libltc is missing to be able to unbundle...

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	jack? ( virtual/jack )"

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
	xdg_src_prepare

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
	local myconf=(
		--configdir=/etc
		--freedesktop
		--noconfirm
		--optimize
		--with-backends=${backends}
		$({ use altivec || use cpu_flags_x86_sse; } && echo "--fpu-optimization" || echo "--no-fpu-optimization")
		$(usex doc "--docs" '')
		$(usex nls "--nls" "--no-nls")
		$(usex phonehome "--phone-home" "--no-phone-home")
		# not possible right now  --use-external-libs
	)

	waf-utils_src_configure "${myconf[@]}"
}

src_compile() {
	waf-utils_src_compile
	use nls && waf-utils_src_compile i18n
}

src_install() {
	local s

	waf-utils_src_install

	mv ${PN}.1 ${PN}${SLOT}.1 || die
	doman ${PN}${SLOT}.1

	for s in 16 22 32 48 256 512; do
		newicon -s ${s} gtk2_ardour/resources/Ardour-icon_${s}px.png ardour${SLOT}.png
	done

	sed -i \
		-e "s/\(^Name=\).*/\1Ardour ${SLOT}/" \
		-e 's/;AudioEditing;/;X-AudioEditing;/' \
		build/gtk2_ardour/ardour${SLOT}.desktop || die
	domenu build/gtk2_ardour/ardour${SLOT}.desktop

	insinto /usr/share/mime/packages
	newins build/gtk2_ardour/ardour.xml ardour${SLOT}.xml

	insinto /usr/share/metainfo
	doins build/gtk2_ardour/ardour${SLOT}.appdata.xml
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Please do _not_ report problems with the package to ${PN} upstream."
	elog "If you think you've found a bug, check the upstream binary package"
	elog "before you report anything to upstream."
}
