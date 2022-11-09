# Copyright 2014-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"
# In alpha26 bundled spidermonkey-78.6.0 does not build with python 3.11.
PYTHON_COMPAT=( python3_10 )
inherit desktop toolchain-funcs multiprocessing python-any-r1 wxwidgets xdg

DESCRIPTION="A free, real-time strategy game"
HOMEPAGE="https://play0ad.com/"
LICENSE="BitstreamVera CC-BY-SA-3.0 GPL-2 LGPL-2.1 LPPL-1.3c MIT ZLIB"
# Upstream signs releases with app-crypt/minisign which is not supported
# by IUSE="verify-sig", bug #783066. As a workaround the minisign key
# is hardcoded and verifed manually in this ebuild.
#
# The public key can be found upstream - last update was w/ alpha 26:
# https://trac.wildfiregames.com/wiki/VerifyingYourDownloads
MINISIGN_KEY="RWTWLbO12+ig3lUExIor3xd6DdZaYFEozn8Bu8nIzY3ImuRYQszIQyyy"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/0ad/0ad"
	S="${WORKDIR}/${P}"
elif [[ ${PV} == *_pre* ]]; then
	ZEROAD_GIT_REVISION="c7d07d3979f969b969211a5e5748fa775f6768a7"
	SRC_URI="https://github.com/0ad/0ad/archive/${ZEROAD_GIT_REVISION}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${ZEROAD_GIT_REVISION}"
else
	# Trailing whitespace for IUSE append below
	IUSE="verify-sig "
	MY_P="0ad-${PV/_/-}"
	SRC_URI="
		http://releases.wildfiregames.com/${MY_P}-unix-build.tar.xz
		https://releases.wildfiregames.com/${MY_P}-unix-data.tar.xz
		verify-sig? (
			http://releases.wildfiregames.com/${MY_P}-unix-build.tar.xz.minisig
			http://releases.wildfiregames.com/${MY_P}-unix-data.tar.xz.minisig
		)
	"
	S="${WORKDIR}/${MY_P}"
fi
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE+="editor +lobby nvtt pch test"

RESTRICT="test"
CHECKREQS_DISK_BUILD="9000M" # 8795916 KiB (8.3 GiB) for alpha 26
CHECKREQS_DISK_USR="3500M" # 3555340 KiB (3.3 GiB)

# Premake adds '-s' to some LDFLAGS. Simply sed'ing it out leads to
# build and/or startup issues.
QA_PRESTRIPPED="/usr/lib64/0ad/libCollada.so /usr/bin/0ad"

# virtual/rust is for bundled SpiderMonkey.
# Build-time Python dependency is for SM, too.
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/premake-5.0.0_alpha12:5
	virtual/pkgconfig
	virtual/rust
	test? ( dev-lang/perl )
"

# For IUSE="verify-sig", see note about SRC_URI block.
if [[ ( ${PV} != *9999 ) && ( ${PV} != *_p* ) ]]; then
	BDEPEND+=" app-crypt/minisign"
fi

# Removed dependency on nvtt as we use the bundled one.
# bug #768930
DEPEND="
	dev-libs/boost:=
	dev-libs/icu:=
	dev-libs/libfmt:0=
	dev-libs/libsodium
	dev-libs/libxml2
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
	editor? ( x11-libs/wxGTK:${WX_GTK_VER}[X,opengl] )
	lobby? ( net-libs/gloox )
"
RDEPEND="
	${DEPEND}
	!games-strategy/0ad-data
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.0.24b_alpha-respect-tc.patch
	"${FILESDIR}"/${PN}-0.0.25b_alpha-fix-setuptools.patch
)

pkg_setup() {
	use editor && setup-wxwidgets

	python-any-r1_pkg_setup
}

src_unpack() {
	if [[ ( ${PV} != *9999 ) && ( ${PV} != *_p* ) ]]; then
		if use verify-sig; then
			elog "Verifying both signatures using app-crypt/minisign."
			minisign -V \
				-P "${MINISIGN_KEY}" \
				-x "${DISTDIR}/${MY_P}-unix-build.tar.xz.minisig" \
				-m "${DISTDIR}/${MY_P}-unix-build.tar.xz" \
				|| die "Failed to verify engine distfile using minisign!"
			minisign -V \
				-P "${MINISIGN_KEY}" \
				-x "${DISTDIR}/${MY_P}-unix-data.tar.xz.minisig" \
				-m "${DISTDIR}/${MY_P}-unix-data.tar.xz" \
				|| die "Failed to verify data distfile using minisign!"
		fi
		# Unpack manually until an eclass supports minisign and unpacks
		# if signatures match.
		default
	else
		# Unpack distfiles without checking as this is no official release.
		default
	fi
}

src_prepare() {
	default

	# SpiderMonkey's configure no longer recognises --build for
	# the build tuple
	sed -i -e "/--build/d" libraries/source/spidermonkey/build.sh || die

	# Originally from 0ad-data
	rm binaries/data/tools/fontbuilder/fonts/*.txt || die
}

src_configure() {
	# 0AD uses premake:5 to generate the Makefiles, so let's
	# 1. configure the configure args,
	# 2. export some toolchain args,
	# 3. configure premake args,
	# 4. run premake5.
	local myconf=(
		--minimal-flags
		$(usex nvtt "" "--without-nvtt")
		$(usex pch "" "--without-pch")
		$(usex test "" "--without-tests")
		$(usex editor "--atlas" "")
		$(usex lobby "" "--without-lobby")
		--bindir="/usr/bin"
		--libdir="/usr/$(get_libdir)"/${PN}
		--datadir="/usr/share/${PN}"
	)

	tc-export AR CC CXX RANLIB

	local mypremakeargs=(
		--outpath="../workspace/gcc"
		--os=linux
		--verbose
	)

	cd "${S}/build/premake" || die "Could not enter premake directory"

	/usr/bin/premake5 "${mypremakeargs[@]}" "${myconf[@]}" gmake2 \
		|| die "Premake failed"
}

src_compile() {
	# Build 3rd party fcollada
	einfo "Building bundled fcollada"
	emake -C libraries/source/fcollada/src

	# Build bundled NVTT
	# nvtt is abandoned upstream and 0ad has forked it and added fixes.
	# Use their copy. bug #768930
	if use nvtt ; then
		cd libraries/source/nvtt || die
		elog "Building bundled NVTT (bug #768930)"
		JOBS="-j$(makeopts_jobs)" ./build.sh || die "Failed to build bundled NVTT"
		cd "${S}" || die
	fi

	# Build bundled SpiderMonkey
	# We really can't use the system SpiderMonkey right now.
	# Breakages occur even on minor bumps in upstream SM,
	# e.g. bug #768840.
	cd libraries/source/spidermonkey || die
	elog "Building bundled SpiderMonkey (bug #768840)"
	XARGS="${EPREFIX}/usr/bin/xargs" \
		JOBS="-j$(makeopts_jobs)" \
		./build.sh \
	|| die "Failed to build bundled SpiderMonkey"

	cd "${S}" || die

	# Build 0ad itself!
	elog "Building 0ad"
	JOBS="-j$(makeopts_jobs)" emake -C build/workspace/gcc verbose=1

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

			einfo pyrogenesis -archivebuild="${archivebuild_input}" -archivebuild-output="${archivebuild_output}/${mod_name}.zip"
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
		rm -r binaries/data/mods/_test.* || die
	fi
}

src_test() {
	cd binaries/system || die
	./test -libdir "${S}/binaries/system" || die "Failed tests"
}

src_install() {
	newbin binaries/system/pyrogenesis 0ad
	use editor && newbin binaries/system/ActorEditor 0ad-ActorEditor

	# Merged from 0ad-data
	# bug #771147 (comment 3)
	insinto /usr/share/${PN}
	doins -r binaries/data/{l10n,config,mods,tools}

	# Install bundled SpiderMonkey and nvtt
	# bug #771147 (comment 1)
	exeinto /usr/$(get_libdir)/${PN}
	doexe binaries/system/{libCollada,libmozjs78-ps-release}.so

	use nvtt && doexe binaries/system/{libnvtt,libnvcore,libnvimage,libnvmath}.so
	use editor && doexe binaries/system/libAtlasUI.so

	dodoc binaries/system/readme.txt
	doicon -s 128 build/resources/${PN}.png
	make_desktop_entry ${PN}
}
