# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_QA_COMPAT_SKIP=1 #android/jni/CMakeLists.txt
inherit cmake toolchain-funcs

MAN_VERS="1.51"
DESCRIPTION="Software speech synthesizer for English, and some other languages"
HOMEPAGE="https://github.com/espeak-ng/espeak-ng"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/espeak-ng/espeak-ng.git"
	inherit git-r3
elif [[ ${PV} == *_p* ]]; then
	HASH_COMMIT=""
	SRC_URI="https://github.com/espeak-ng/espeak-ng/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${HASH_COMMIT}"
else
	SRC_URI="https://github.com/espeak-ng/espeak-ng/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-3+ unicode"
SLOT="0"
IUSE="+klatt mbrola sonic +sound test"
IUSE+=" l10n_ru l10n_zh"
RESTRICT="!test? ( test )"

DEPEND="
	mbrola? ( app-accessibility/mbrola )
	sonic? ( media-libs/sonic:= )
	sound? ( media-libs/pcaudiolib )
"
RDEPEND="${DEPEND}
	!app-accessibility/espeak
"
BDEPEND="virtual/pkgconfig"
if [[ ${PV} == *9999* ]]; then
	BDEPEND+=" app-text/ronn-ng"
fi

DOCS=( ChangeLog.md README.md docs )

PATCHES=(
	# PR pending https://github.com/espeak-ng/espeak-ng/pull/2394
	"${FILESDIR}"/${PN}-1.52.1-path_pkgconfig.patch
	# PR pending https://github.com/espeak-ng/espeak-ng/pull/2399
	"${FILESDIR}"/${PN}-1.52.1-rm_which.patch
)

src_prepare() {
	cmake_src_prepare

	if [[ ${PV} != *9999* ]]; then
		cp "${FILESDIR}"/${PN}.1-${MAN_VERS} "${S}"/docs/${PN}.1 || die
	fi

	if ! use klatt; then
		sed -e '/test_wav "en+klatt4"/d' -i tests/variants.test || die
	fi

	if ! use l10n_ru; then
		sed -e '/test_phon ru/d' -i tests/language-pronunciation.test || die
	fi

	if ! use l10n_zh; then
		sed -e '/test_phon cmn/d' -i tests/translate.test || die
	fi
}

src_configure() {
	_need_native() {
		if ! tc-is-cross-compiler; then
			return 1
		fi

		if ! has_version -b ">=${CATEGORY}/${P}"; then
			return 0
		fi

		if "${BROOT}"/usr/bin/espeak-ng --version &> /dev/null ; then
			return 2
		else
			return 0
		fi

		return 1
	}

	if _need_native; then
		einfo "Building native espeak-ng-bin for intonations..."

		BUILD_NATIVE="${WORKDIR}/${P}_build_native"
		local mycmakeargs=(
			-DCOMPILE_INTONATIONS=ON
			-DUSE_SPEECHPLAYER=OFF
			-DESPEAK_BUILD_MANPAGES=OFF
			-DSONIC_LIB=1
			-DSONIC_INC=1
			-DUSE_KLATT=OFF
			-DUSE_MBROLA=OFF
			-DUSE_LIBSONIC=OFF
			-DUSE_LIBPCAUDIO=OFF
			-DENABLE_TESTS=OFF
		)

		BUILD_DIR="${BUILD_NATIVE}" tc-env_build cmake_src_configure

		# create an empty program for now
		touch "${BUILD_NATIVE}"/src/espeak-ng || die
		# make it executable (CMP0109)
		chmod +x "${BUILD_NATIVE}"/src/espeak-ng || die
	fi

	# https://bugs.gentoo.org/836646
	export PULSE_SERVER=""

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCOMPILE_INTONATIONS=ON
		# outdated, not packaged
		-DUSE_SPEECHPLAYER=OFF

		-DUSE_KLATT=$(usex klatt)
		-DUSE_MBROLA=$(usex mbrola)
		-DUSE_LIBSONIC=$(usex sonic)
		# or sonic will be fetched even if it's disabled
		# see also https://github.com/espeak-ng/espeak-ng/issues/2273
		$(usev !sonic '-DSONIC_LIB=1 -DSONIC_INC=1')
		-DUSE_LIBPCAUDIO=$(usex sound)
		-DENABLE_TESTS=$(usex test)

		# extended dictionaries
		-DEXTRA_ru=$(usex l10n_ru)
		-DEXTRA_cmn=$(usex l10n_zh)
		-DEXTRA_yue=$(usex l10n_zh)
	)

	if [[ ${PV} == *9999* ]]; then
		mycmakeargs+=( -DESPEAK_BUILD_MANPAGES=ON )
	else
		# use precompiled for releases
		mycmakeargs+=( -DESPEAK_BUILD_MANPAGES=OFF )
	fi

	_need_native
	case $? in
		0) mycmakeargs+=( -DNativeBuild_DIR="${BUILD_NATIVE}/src" ) ;;
		2) mycmakeargs+=( -DNativeBuild_DIR="${BROOT}/usr/bin" ) ;;
	esac

	cmake_src_configure
}

src_compile() {
	if _need_native; then
		BUILD_DIR="${BUILD_NATIVE}" tc-env_build cmake_build espeak-ng-bin
	fi

	cmake_src_compile
}

src_install() {
	cmake_src_install

	[[ ${PV} == *9999* ]] || doman docs/${PN}.1
}
