# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE='threads(+)'
inherit desktop edo flag-o-matic optfeature python-any-r1 waf-utils toolchain-funcs xdg

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="https://ardour.org/"

if [[ ${PV} == *9999* ]]; then
	# Main repo not stable
	#EGIT_REPO_URI="https://git.ardour.org/ardour/ardour.git"
	EGIT_REPO_URI="https://github.com/Ardour/ardour.git"
	inherit git-r3
else
	# We previously had 8.12 instead of 8.12.0 despite SRC_URI + S
	[[ ${PV} != 8.12 ]] && die "Please fix the version to be X.Y.Z instead of X.Y on this next bump!"
	# upstream doesn't provide a release tarball in github repo
	# see https://github.com/Ardour/ardour/blob/master/README-GITHUB.txt
	# official link is available here, but with token/expiration:
	# https://community.ardour.org/download?architecture=x86_64&type=source
	SRC_URI="https://dev.gentoo.org/~fordfrog/distfiles/Ardour-${PV}.0.tar.bz2"
	S="${WORKDIR}/Ardour-${PV}.0"
	KEYWORDS="amd64 ~loong ~x86"
fi

LICENSE="GPL-2"
SLOT="8"
IUSE="doc jack phonehome pulseaudio test"
CPU_USE=(
	cpu_flags_x86_{avx,avx512f,fma3,sse}
)
IUSE+=" ${CPU_USE[@]}"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/libarchive:=
	dev-cpp/cairomm:0[X]
	dev-cpp/glibmm:2
	dev-cpp/pangomm:1.4
	dev-libs/glib:2
	dev-libs/libsigc++:2
	dev-libs/libxml2:2=
	media-libs/alsa-lib
	media-libs/aubio:=
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/liblo
	media-libs/liblrdf
	media-libs/libpng:=
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/lilv
	media-libs/lv2
	media-libs/raptor:2
	media-libs/rubberband:=
	media-libs/taglib:=
	media-libs/vamp-plugin-sdk
	net-libs/libwebsockets:=
	net-misc/curl
	sys-apps/dbus
	sys-libs/readline:0=
	sci-libs/fftw:3.0=[threads]
	virtual/libusb:1
	x11-libs/cairo[X]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/pango
	x11-themes/hicolor-icon-theme
	jack? ( virtual/jack )
	pulseaudio? ( media-libs/libpulse )
"
#	media-libs/suil[X,gtk2] bundled suil is used, maybe probably because of ytk
#	!bundled-libs? ( media-sound/fluidsynth ) at least libltc is missing to be able to unbundle...
DEPEND="
	${RDEPEND}
	dev-libs/boost
	dev-libs/sord
	media-libs/sratom
	test? ( dev-util/cppunit )
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-9.0.0-fix-clang-crash.patch"
	"${FILESDIR}/${PN}-9.0.0-properly-check-for-syscall.patch"
	"${FILESDIR}/${PN}-9.0.0-fix-unlikely-buffer-overflow.patch"
	"${FILESDIR}/${PN}-8.12-fix_fpu.patch"
	# see bug #966219
	"${FILESDIR}/${PN}-8.12-fix_fftranscode.patch"
)

src_prepare() {
	default

	local optflags=(
		$(usev cpu_flags_x86_sse sse)
	)
	# these flags imply sse and avx
	if use cpu_flags_x86_sse && use cpu_flags_x86_avx; then
		optflags+=(
			avx
			$(usev cpu_flags_x86_avx512f avx512f)
			$(usev cpu_flags_x86_fma3 fma)
		)
	fi

	# use only flags defined by users
	sed 's/flag_line = o.*/flag_line = \": '"${optflags[*]}"'\"/' \
		-i wscript || die

	# shebang
	python_fix_shebang wscript
	python_fix_shebang waf

	# fix hardcoded cpp, apply `gcc -E` needs patching but will fail w/ clang
	tc-export CPP
	sed -e "s@obj.command = 'cpp'@obj.command = '${CPP/-gcc -E/-cpp}'@" \
		-i gtk2_ardour/wscript || die

	# skip non-generic tests with failures
	sed -e "\@'test/fpu_test.cc',@d" -i libs/ardour/wscript || die
}

src_configure() {
	# avoid bug https://bugs.gentoo.org/800067
	local -x AS="$(tc-getCC) -c"

	# -Werror=odr
	# https://tracker.ardour.org/view.php?id=9649
	# https://bugs.gentoo.org/917095
	filter-lto

	append-ldflags -Wl,-rpath,"${EPREFIX}/usr/$(get_libdir)/ardour${SLOT}"

	local backends=(
		alsa
		dummy
		$(usev jack)
		$(usev pulseaudio)
	)

	# VST support is enabled by default given --no-lxvst is not called.
	# But please keep in mind the README (obsolete?) made by upstream.
	# https://github.com/Ardour/ardour/blob/master/PACKAGER_README

	tc-export CC CXX
	local myconf=(
		--configdir="${EPREFIX}"/etc
		--cxx17
		--freedesktop
		--noconfirm
		--optimize
		--with-backends=$(IFS=','; echo "${backends[*]}")
		$(usev !cpu_flags_x86_sse --no-fpu-optimization)
		$(usev !phonehome --no-phone-home)
		$(usev test --test)
		# not possible right now  --use-external-libs
		# missing dependency: https://github.com/c4dm/qm-dsp
	)

	waf-utils_src_configure "${myconf[@]}"
}

src_compile() {
	waf-utils_src_compile
	waf-utils_src_compile i18n
	if use doc; then
		pushd doc >/dev/null || die
		doxygen -u Doxyfile || die
		doxygen Doxyfile || die
		find . \( -iname '*.map' -o -iname '*.md5' \) -delete || die
		popd >/dev/null || die
	fi
}

src_test() {
	pushd "${S}"/libs/ardour/ >/dev/null || die
	edo ./run-tests.sh
	popd >/dev/null || die
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )

	waf-utils_src_install

	mv ${PN}.1 ${PN}${SLOT}.1 || die
	doman ${PN}${SLOT}.1

	local s
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
	rm "${D}/usr/share/mime/packages/ardour.xml" || die

	# the appdata directory is deprecated
	# no patch because this causes the translation fail
	mv "${ED}"/usr/share/{appdata,metainfo} || die

	if use test; then
		# do not install the testsuite
		rm "${ED}"/usr/bin/run-tests || die
		rm "${ED}"/usr/$(get_libdir)/ardour${SLOT}/run-tests || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "another synth used by default if installed" media-plugins/gmsynth-lv2
	optfeature "exporting audio in mp3" media-video/ffmpeg[lame]

	elog "Please do _not_ report problems with the package to ${PN} upstream."
	elog "If you think you've found a bug, check the upstream binary package"
	elog "before you report anything to upstream."
}
