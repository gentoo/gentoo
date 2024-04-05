# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix toolchain-funcs flag-o-matic

NO_DOT_PV=$(ver_rs 1- '')
DESCRIPTION="A free file archiver for extremely high compression"
HOMEPAGE="https://www.7-zip.org/ https://sourceforge.net/projects/sevenzip/"
SRC_URI="
	https://sourceforge.net/projects/sevenzip/files/7-Zip/${PV}/7z${NO_DOT_PV}-src.tar.xz/download -> ${PN}-${PV}.tar.xz
	https://sourceforge.net/projects/sevenzip/files/7-Zip/${PV}/7z${NO_DOT_PV}-linux-x64.tar.xz/download -> ${PN}-${PV}-linux.tar.xz
"
LICENSE="LGPL-2 BSD rar? ( unRAR )"

IUSE="uasm jwasm rar"
REQUIRED_USE="?? ( uasm jwasm )"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/CPP/7zip/"
DOCS=( readme.txt History.txt License.txt )
HTML_DOCS=( MANUAL )
RESTRICT="mirror"

DEPEND="${RDEPEND}"
BDEPEND="
	uasm? ( dev-lang/uasm )
	jwasm? ( dev-lang/jwasm )
"

# TODO(NRK): also build and install the library
# TODO(NRK): make it so this package can be used as a drop-in replacement
# for app-arch/p7zip ??

pkg_setup() {
	# instructions in DOC/readme.txt, Compiling 7-Zip for Unix/Linux
	# TLDR; every combination of options (clang|gcc)+(asm/noasm)
	# has a dedicated makefile & builddir
	mfile="cmpl"
	if tc-is-clang; then
		mfile="${mfile}_clang"
		bdir=c
	elif tc-is-gcc; then
		mfile="${mfile}_gcc"
		bdir=g
	else
		die "Unsupported compiler: $(tc-getCC)"
	fi
	if use jwasm || use uasm ; then
		mfile="${mfile}_x64"
		bdir="${bdir}_x64"
	fi
	export mfile="${mfile}.mak"
	export bdir
}

src_prepare() {
	# patch doesn't deal with CRLF even if file+patch match
	# not even with --ignore-whitespace, --binary or --force
	edos2unix ./7zip_gcc.mak ./var_gcc{,_x64}.mak ./var_clang{,_x64}.mak
	PATCHES+=( "${FILESDIR}/${P}-respect-build-env.patch" )

	sed -i -e 's/-Werror //g' ./7zip_gcc.mak || die "Error removing -Werror"
	default
}

src_compile() {
	pushd "./Bundles/Alone2" || die "Unable to switch directory"
	append-ldflags -Wl,-z,noexecstack
	export G_CFLAGS=${CFLAGS}
	export G_CXXFLAGS=${CXXFLAGS}
	export G_LDFLAGS=${LDFLAGS}
	local args=(
		-f "../../${mfile}"
		CC=$(tc-getCC)
		CXX=$(tc-getCXX)
	)
	# NOTE: makefile doesn't check the value of DISABLE_RAR_COMPRESS, only
	# whether it's defined or not. so in case user has `rar` enabled
	# DISABLE_RAR_COMPRESS (and DISABLE_RAR) needs to stay undefined.
	if ! use rar; then
		# disables non-free rar code but allows listing and extracting
		# non-compressed rar archives
		args+=(DISABLE_RAR_COMPRESS=1)
	fi
	if use jwasm; then
		args+=(USE_JWASM=1)
	elif use uasm; then
		args+=(MY_ASM=uasm)
	fi
	emake ${args[@]}
	popd > /dev/null || die "Unable to switch directory"
}

src_install() {
	dobin "./Bundles/Alone2/b/${bdir}/7zz"

	pushd "${WORKDIR}" || die "Unable to switch directory"
	einstalldocs
}
