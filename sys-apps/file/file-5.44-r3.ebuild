# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 libtool toolchain-funcs multilib-minimal

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/glensc/file.git"
	inherit autotools git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/file.asc
	inherit verify-sig
	SRC_URI="ftp://ftp.astron.com/pub/file/${P}.tar.gz"
	SRC_URI+=" verify-sig? ( ftp://ftp.astron.com/pub/file/${P}.tar.gz.asc )"

	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-file )"
fi

DESCRIPTION="Identify a file's format by scanning binary data for patterns"
HOMEPAGE="https://www.darwinsys.com/file/"

LICENSE="BSD-2"
SLOT="0"
IUSE="bzip2 lzip lzma python seccomp static-libs zlib zstd"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	lzip? ( app-arch/lzlib )
	lzma? ( app-arch/xz-utils[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
	seccomp? ( >=sys-libs/libseccomp-2.5.4[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
	python? ( !dev-python/python-magic )
	seccomp? ( >=sys-libs/libseccomp-2.5.4[${MULTILIB_USEDEP}] )
"
BDEPEND+="
	python? (
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
	)
"

PATCHES=(
	"${FILESDIR}/file-5.43-seccomp-fstatat64-musl.patch" #789336, not upstream yet
	"${FILESDIR}/file-5.43-portage-sandbox.patch" #889046
	"${FILESDIR}/file-5.44-limits-solaris.patch" # applied upstream
	"${FILESDIR}/file-5.44-seccomp-utimes.patch" # upstream
	"${FILESDIR}/file-5.44-decompress-empty.patch" # upstream
)

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	else
		elibtoolize
	fi

	# Don't let python README kill main README, bug ##60043
	mv python/README.md python/README.python.md || die

	# bug #662090
	sed 's@README.md@README.python.md@' -i python/setup.py || die
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-fsect-man5
		$(use_enable bzip2 bzlib)
		$(multilib_native_use_enable lzip lzlib)
		$(use_enable lzma xzlib)
		$(use_enable seccomp libseccomp)
		$(use_enable static-libs static)
		$(use_enable zlib)
		$(use_enable zstd zstdlib)
	)

	econf "${myeconfargs[@]}"
}

build_src_configure() {
	local myeconfargs=(
		--disable-shared
		--disable-libseccomp
		--disable-bzlib
		--disable-xzlib
		--disable-zlib
	)

	econf_build "${myeconfargs[@]}"
}

need_build_file() {
	# When cross-compiling, we need to build up our own file
	# because people often don't keep matching host/target
	# file versions, bug #362941
	tc-is-cross-compiler && ! has_version -b "~${CATEGORY}/${P}"
}

src_configure() {
	local ECONF_SOURCE="${S}"

	if need_build_file ; then
		mkdir -p "${WORKDIR}"/build || die
		cd "${WORKDIR}"/build || die
		build_src_configure
	fi

	multilib-minimal_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi ; then
		emake
	else
		# bug #586444
		emake -C src magic.h
		emake -C src libmagic.la
	fi
}

src_compile() {
	if need_build_file ; then
		# bug #586444
		emake -C "${WORKDIR}"/build/src magic.h
		emake -C "${WORKDIR}"/build/src file
		local -x PATH="${WORKDIR}/build/src:${PATH}"
	fi

	multilib-minimal_src_compile

	if use python ; then
		cd python || die
		distutils-r1_src_compile
	fi
}

multilib_src_install() {
	if multilib_is_native_abi ; then
		default
	else
		emake -C src install-{nodist_includeHEADERS,libLTLIBRARIES} DESTDIR="${D}"
	fi
}

multilib_src_install_all() {
	dodoc ChangeLog MAINT # README

	# Required for `file -C`
	insinto /usr/share/misc/magic
	doins -r magic/Magdir/*

	if use python ; then
		cd python || die
		distutils-r1_src_install
	fi

	find "${ED}" -type f -name "*.la" -delete || die
}
