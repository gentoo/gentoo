# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit edo flag-o-matic multiprocessing python-any-r1 toolchain-funcs xdg

DESCRIPTION="Open-source, GPL-licensed, multiplatform, multithreaded video transcoder"
HOMEPAGE="https://handbrake.fr/ https://github.com/HandBrake/HandBrake"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/HandBrake/HandBrake.git"
	inherit git-r3
else
	MY_P="HandBrake-${PV}"
	SRC_URI="https://github.com/HandBrake/HandBrake/releases/download/${PV}/${MY_P}-source.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

# contrib/<project>/module.defs
declare -A BUNDLED=(
	# Heavily patched in an incompatible way.
	# Issues related to using system ffmpeg historically.
	# See bug #829595 and #922828
	[ffmpeg]="https://github.com/HandBrake/HandBrake-contribs/releases/download/contribs2/ffmpeg-7.1.1.tar.bz2;"
	# Patched in an incompatible way
	[x265]="https://github.com/HandBrake/HandBrake-contribs/releases/download/contribs2/x265-snapshot-20250729-13276.tar.gz;x265"
	[x265_8bit]="https://github.com/HandBrake/HandBrake-contribs/releases/download/contribs2/x265-snapshot-20250729-13276.tar.gz;x265"
	[x265_10bit]="https://github.com/HandBrake/HandBrake-contribs/releases/download/contribs2/x265-snapshot-20250729-13276.tar.gz;x265"
	[x265_12bit]="https://github.com/HandBrake/HandBrake-contribs/releases/download/contribs2/x265-snapshot-20250729-13276.tar.gz;x265"
)

bundle_src_uri() {
	for name in "${!BUNDLED[@]}"; do
		IFS=$';' read -r uri use <<< ${BUNDLED[${name}]}
		local tarball=${uri##*/}
		if [[ -n ${use} ]]; then
			SRC_URI+=" ${use}? ( ${uri} -> handbrake-${tarball} )"
		else
			SRC_URI+=" ${uri} -> handbrake-${tarball}"
		fi
	done
}

bundle_src_uri

LICENSE="GPL-2"
SLOT="0"
IUSE="amf +fdk gui libdovi numa nvenc qsv x265"

REQUIRED_USE="numa? ( x265 )"

# >=media-libs/libvpl-1.13.0: bug #957811 (check libhb/qsvcommon.h for new platform codenames)
COMMON_DEPEND="
	app-arch/bzip2
	>=app-arch/xz-utils-5.2.6
	dev-libs/jansson:=
	>=media-libs/dav1d-1.0.0:=
	>=media-libs/libjpeg-turbo-2.1.4:=
	>=media-libs/libass-0.16.0:=
	>=media-libs/libbluray-1.3.4:=
	media-libs/libdvdnav
	>=media-libs/libdvdread-6.1.3:=
	media-libs/libtheora:=
	media-libs/libvorbis
	>=media-libs/libvpx-1.12.0:=
	media-libs/opus
	>=media-libs/speex-1.2.1
	>=media-libs/svt-av1-3.0.0:=
	>=media-libs/x264-0.0.20220222:=
	>=media-libs/zimg-3.0.4
	media-sound/lame
	sys-libs/zlib
	fdk? ( media-libs/fdk-aac:= )
	libdovi? ( media-libs/libdovi:= )
	gui? (
		>=gui-libs/gtk-4.4:4[gstreamer]
		dev-libs/glib:2
		>=dev-libs/libxml2-2.10.3:=
		x11-libs/gdk-pixbuf:2
		x11-libs/pango
	)
	numa? ( sys-process/numactl )
	nvenc? ( media-libs/nv-codec-headers )
	qsv? (
		media-libs/libva:=
		>=media-libs/libvpl-1.13.0:=
	)
"
RDEPEND="
	${COMMON_DEPEND}
	amf? ( media-video/amdgpu-pro-amf )
"
DEPEND="
	${COMMON_DEPEND}
	amf? ( media-libs/amf-headers )
"
# cmake needed for custom script: bug #852701
BDEPEND="
	${PYTHON_DEPS}
	dev-build/cmake
	dev-lang/nasm
	gui? (
		dev-build/meson
		sys-devel/gettext
	)
"

PATCHES=(
	"${FILESDIR}"/handbrake-1.9.0-link-libdovi-properly.patch
	"${FILESDIR}"/handbrake-1.9.0-include-vpl-properly.patch
	"${FILESDIR}"/handbrake-1.9.2-set-ffmpeg-toolchain-explicitly.patch
	"${FILESDIR}"/handbrake-1.9.2-allow-overriding-tools-via-env.patch
)

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.bz2
	fi
}

src_prepare() {
	default

	mkdir download || die
	for name in "${!BUNDLED[@]}"; do
		IFS=$';' read -r uri use <<< ${BUNDLED[${name}]}
		local tarball="${uri##*/}"
		if [[ -n ${use} ]]; then
			use ${use} || continue
		fi
		cp "${DISTDIR}/handbrake-${tarball}" download/${tarball} || die
	done

	# Get rid of leftover bundled library build definitions
	sed -i -E \
		-e "/MODULES \+= contrib\// { /($(IFS=$'|'; echo "${!BUNDLED[*]}"))$/! d }" \
		"${S}"/make/include/main.defs || die

	# noop fetching
	sed -i -e '/DF..*.exe/ { s/= .*/= true/ }' make/include/tool.defs || die

	# Use whichever python is set by portage
	sed -i -e "s/for p in .*/for p in ${EPYTHON}/" configure || die
}

src_configure() {
	tc-export CC CXX AR RANLIB NM

	# noop strip
	local -x STRIP="true"

	# ODR violations, lto-type-mismatches
	# bug #878899
	filter-lto

	local myconfargs=(
		--force
		--verbose
		--disable-df-fetch
		--disable-df-verify
		--launch-jobs=$(get_makeopts_jobs)
		--prefix="${EPREFIX}/usr"
		--disable-flatpak
		--no-harden #bug #890279
		$(use_enable amf vce)
		$(use_enable fdk fdk-aac)
		$(use_enable gui gtk)
		$(use_enable libdovi)
		$(use_enable numa)
		$(use_enable nvenc)
		$(use_enable x265)
		$(use_enable qsv)
	)

	edo ./configure ${myconfargs[@]}
}

src_compile() {
	emake -C build
}

src_install() {
	emake -C build DESTDIR="${D}" install
	dodoc README.markdown AUTHORS.markdown NEWS.markdown THANKS.markdown
}

pkg_postinst() {
	einfo "Gentoo builds of HandBrake are NOT SUPPORTED by upstream as they"
	einfo "do not use the bundled (and often patched) upstream libraries."
	einfo ""
	einfo "Please do not raise bugs with upstream because of these ebuilds,"
	einfo "report bugs to Gentoo's bugzilla or Multimedia forum instead."

	einfo "For the CLI version of HandBrake, you can use \`HandBrakeCLI\`."
	if use gui ; then
		einfo "For the GUI version of HandBrake, you can run \`ghb\`."
	fi

	xdg_pkg_postinst
}
