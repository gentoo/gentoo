# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix flag-o-matic toolchain-funcs

NO_DOT_PV=$(ver_rs 1- '')
DESCRIPTION="Free file archiver for extremely high compression"
HOMEPAGE="https://www.7-zip.org/ https://sourceforge.net/projects/sevenzip/"
# linux-x64 tarball is only used for docs
SRC_URI="
	https://github.com/ip7z/7zip/releases/download/${PV}/7z${NO_DOT_PV}-src.tar.xz
	https://github.com/ip7z/7zip/releases/download/${PV}/7z${NO_DOT_PV}-linux-x64.tar.xz
"
S="${WORKDIR}"

LICENSE="LGPL-2 BSD rar? ( unRAR )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="uasm jwasm rar +symlink"
REQUIRED_USE="?? ( uasm jwasm )"

DOCS=( readme.txt History.txt License.txt )
HTML_DOCS=( MANUAL )

BDEPEND="
	app-arch/xz-utils[extra-filters(+)]
	uasm? ( dev-lang/uasm )
	jwasm? ( dev-lang/jwasm )
"
RDEPEND="
	symlink? ( !app-arch/p7zip )
"

PATCHES=(
	"${FILESDIR}/${PN}-24.05-respect-build-env.patch"
)

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
	pushd "./CPP/7zip" || die "Unable to switch directory"
	edos2unix ./7zip_gcc.mak ./var_gcc{,_x64}.mak ./var_clang{,_x64}.mak
	sed -i -e 's/-Werror //g' ./7zip_gcc.mak || die "Error removing -Werror"
	popd >/dev/null || die "Unable to switch directory"

	default
}

src_compile() {
	# avoid executable stack when using uasm/jwasm, harmless otherwise
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
		args+=( DISABLE_RAR_COMPRESS=1 )
	fi
	if use jwasm; then
		args+=( USE_JWASM=1 )
	elif use uasm; then
		args+=( MY_ASM=uasm )
	fi

	# Build executable and library
	for i in "./CPP/7zip/Bundles/Alone2" "./CPP/7zip/Bundles/Format7zF" ; do
		pushd "${i}" || die "Unable to switch directory"
		mkdir -p "${bdir}" || die  # Bug: https://bugs.gentoo.org/933619
		emake ${args[@]}
		popd > /dev/null || die "Unable to switch directory"
	done
}

src_install() {
	dobin "./CPP/7zip/Bundles/Alone2/b/${bdir}/7zz"
	dolib.so "./CPP/7zip/Bundles/Format7zF/b/${bdir}/7z.so"
	if use symlink; then
		dosym 7zz /usr/bin/7z
		dosym 7zz /usr/bin/7za
		dosym 7zz /usr/bin/7zr
	fi
	einstalldocs
}
