# Copyright 2014-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12,13})
WX_GTK_VER="3.2-gtk3"
inherit desktop flag-o-matic python-any-r1 toolchain-funcs multiprocessing wxwidgets xdg

if [[ ${PV} != 9999 && ${PV} != *_pre* ]]; then
	VERIFY_SIG_METHOD=minisig
	# The public key can be found upstream - last update was w/ alpha 26:
	# https://gitea.wildfiregames.com/0ad/0ad/wiki/VerifyingYourDownloads
	VERIFY_SIG_OPENPGP_KEY_PATH=${FILESDIR}/0ad-minisign.pub
	inherit verify-sig
fi

DESCRIPTION="A free, real-time strategy game"
HOMEPAGE="https://play0ad.com/"
LICENSE="BitstreamVera CC-BY-SA-3.0 GPL-2 LGPL-2.1 LPPL-1.3c MIT ZLIB"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/0ad/0ad"
	S="${WORKDIR}/${P}"
elif [[ ${PV} == *_pre* ]]; then
	ZEROAD_GIT_REVISION=""
	SRC_URI="https://github.com/0ad/0ad/archive/${ZEROAD_GIT_REVISION}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${ZEROAD_GIT_REVISION}"
elif [[ ${PV} == *_rc* ]]; then
	MY_P="0ad-${PV/_/-}"
	SRC_URI="
		https://releases.wildfiregames.com/rc/${MY_P}-unix-build.tar.xz
		https://releases.wildfiregames.com/rc/${MY_P}-unix-data.tar.xz
		verify-sig? (
			https://releases.wildfiregames.com/rc/${MY_P}-unix-build.tar.xz.minisig
			https://releases.wildfiregames.com/rc/${MY_P}-unix-data.tar.xz.minisig
		)
	"
	S="${WORKDIR}/${MY_P/-rc*/}"
else
	MY_P="0ad-${PV/_/-}"
	SRC_URI="
		https://releases.wildfiregames.com/${MY_P}-unix-build.tar.xz
		https://releases.wildfiregames.com/${MY_P}-unix-data.tar.xz
		verify-sig? (
			https://releases.wildfiregames.com/${MY_P}-unix-build.tar.xz.minisig
			https://releases.wildfiregames.com/${MY_P}-unix-data.tar.xz.minisig
		)
	"
	S="${WORKDIR}/${MY_P}"
fi
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="editor +lobby nvtt pch test"

RESTRICT="!test? ( test )"
CHECKREQS_DISK_BUILD="4000M" # 3842680 KiB (3.6 GiB) for alpha 27
CHECKREQS_DISK_USR="3500M" # 3452564 KiB (3.2 GiB)

BDEPEND="
	>=dev-util/premake-5.0.0_alpha12:5
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"

# Removed dependency on nvtt as we use the bundled one.
# bug #768930
# TODO: use system cxxtest
DEPEND="
	dev-lang/spidermonkey:115
	dev-libs/boost:=
	dev-libs/icu:=
	dev-libs/libfmt:0=
	dev-libs/libsodium:=
	dev-libs/libxml2:=
	media-libs/libpng:0
	media-libs/libsdl2[X,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	net-libs/enet:1.3
	net-libs/miniupnpc:=
	net-misc/curl
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	editor? ( x11-libs/wxGTK:${WX_GTK_VER}=[X,opengl] )
	lobby? ( net-libs/gloox )
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	# https://gitea.wildfiregames.com/0ad/0ad/issues/7534
	"${FILESDIR}/${PN}-0.27.0-fix-tests.patch"
)

src_prepare() {
	default

	# bundled nvtt: -Wodr
	filter-lto

	# Originally from 0ad-data
	rm binaries/data/tools/fontbuilder/fonts/*.txt || die

	# Delete test needing network access
	rm source/network/tests/test_StunClient.h || die
}

src_configure() {
	# 0AD uses premake:5 to generate the Makefiles, so let's
	# 1. configure the configure args,
	# 2. export some toolchain args,
	# 3. configure premake args,
	# 4. run premake5.
	local myconf=(
		--minimal-flags
		--with-system-mozjs
		$(usex nvtt "" "--without-nvtt")
		$(usex pch "" "--without-pch")
		$(usex test "" "--without-tests")
		$(usex editor "" "--without-atlas")
		$(usex lobby "" "--without-lobby")
		--bindir="/usr/bin"
		--libdir="/usr/$(get_libdir)"/${PN}
		--datadir="/usr/share/${PN}"
	)

	tc-export AR CC CXX RANLIB

	local mypremakeargs=(
		--file=build/premake/premake5.lua
		--os=linux
		--verbose
	)

	use editor && setup-wxwidgets

	premake5 "${mypremakeargs[@]}" "${myconf[@]}" gmake2 \
		|| die "Premake failed"
}

src_compile() {
	# Build 3rd party fcollada
	einfo "Building bundled fcollada"
	JOBS="-j$(makeopts_jobs)" ./libraries/source/fcollada/build.sh || die "Failed to build bundled fcollada"

	# Build bundled NVTT
	# nvtt is abandoned upstream and 0ad has forked it and added fixes.
	# Use their copy. bug #768930
	if use nvtt; then
		elog "Building bundled NVTT (bug #768930)"
		JOBS="-j$(makeopts_jobs)" ./libraries/source/nvtt/build.sh || die "Failed to build bundled NVTT"
	fi

	# Shouldn't be needed with tests disabled, unfortunatly it still is for a27
	# https://gitea.wildfiregames.com/0ad/0ad/issues/7537
	einfo "Building bundled cxxtest"
	JOBS="-j$(makeopts_jobs)" ./libraries/source/cxxtest-4.4/build.sh || die "Failed to build bundled cxxtest"

	# Build 0ad itself!
	elog "Building 0ad"
	emake -C build/workspaces/default config=release verbose=1

	# Build assets
	# (We only do this if we're using a snapshot/non-release)
	# See bug #771147 (comment 3) and the old 0ad-data ebuild
	# Warning: fragile!
	if [[ ${PV} == 9999 || ${PV} == *_pre* ]]; then
		# source/lib/sysdep/os/linux/ldbg.cpp:debug_SetThreadName() tries to open /proc/self/task/${TID}/comm for writing.
		addpredict /proc/self/task

		# Based on source/tools/dist/build-archives.sh used by source/tools/dist/build.sh.
		local archivebuild_input archivebuild_output mod_name
		for archivebuild_input in binaries/data/mods/[A-Za-z0-9]*; do
			mod_name="${archivebuild_input##*/}"
			archivebuild_output="archives/${mod_name}"

			mkdir -p "${archivebuild_output}" || die

			einfo pyrogenesis -archivebuild="${archivebuild_input}" \
				-archivebuild-output="${archivebuild_output}/${mod_name}.zip"
			LD_LIBRARY_PATH="binaries/system" binaries/system/pyrogenesis \
				-archivebuild="${archivebuild_input}" \
				-archivebuild-output="${archivebuild_output}/${mod_name}.zip" \
			|| die "Failed to build assets"

			if [[ -f "${archivebuild_input}/mod.json" ]]; then
				cp "${archivebuild_input}/mod.json" "${archivebuild_output}" || die
			fi

			rm -r "${archivebuild_input}" || die
			mv "${archivebuild_output}" "${archivebuild_input}" || die
		done

		# Based on source/tools/dist/build-unix-win32.sh used by source/tools/dist/build.sh.
		rm binaries/data/config/dev.cfg || die
	fi
}

# Removed test requiring network access in src_configure
src_test() {
	LD_LIBRARY_PATH=$(realpath libraries/source/nvtt/lib/) \
		./binaries/system/test --libdir "${S}/binaries/system" || die "Failed tests"
}

src_install() {
	# Remove font files only used to generate font bitmaps
	rm -r binaries/data/tools/fontbuilder/ || die
	# Remove transifex tooling configuration
	rm -r binaries/data/l10n/{.tx,messages.json} || die
	# Remove test only data
	rm -r binaries/data/mods/_test.* || die

	newbin binaries/system/pyrogenesis 0ad
	use editor && newbin binaries/system/ActorEditor 0ad-ActorEditor

	# Merged from 0ad-data
	# bug #771147 (comment 3)
	insinto /usr/share/${PN}
	doins -r binaries/data/{l10n,config,mods,tools}

	# Install bundled nvtt
	# bug #771147 (comment 1)
	exeinto /usr/$(get_libdir)/${PN}
	doexe binaries/system/libCollada.so
	use nvtt && doexe libraries/source/nvtt/lib/{libnvtt,libnvcore,libnvimage,libnvmath}.so
	use editor && doexe binaries/system/libAtlasUI.so

	dodoc binaries/system/readme.txt
	doicon -s 128 build/resources/${PN}.png
	make_desktop_entry ${PN}
}
