# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

DESCRIPTION="unix-like reverse engineering framework and commandline tools"
HOMEPAGE="http://www.radare.org"

ARM64_COMMIT=3c5eaba46dab72ecb7d5f5b865a13fdeee95b464
ARMV7_COMMIT=dde39f69ffea19fc37e681874b12cb4707bc4f30
BINS_COMMIT=a6d1a0331605b4a5db9aa9260386c850d484dc70

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/radareorg/radare2"
else
	SRC_URI="https://github.com/radareorg/radare2/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/radareorg/vector35-arch-arm64/archive/${ARM64_COMMIT}.tar.gz -> ${P}-vector35-arm64.tar.gz
		https://github.com/radareorg/vector35-arch-armv7/archive/${ARMV7_COMMIT}.tar.gz -> ${P}-vector35-armv7.tar.gz
		test? ( https://github.com/radareorg/radare2-testbins/archive/${BINS_COMMIT}.tar.gz -> radare2-testbins-${BINS_COMMIT}.tar.gz )
	"

	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="ssl test"

# Need to audit licenses of the binaries used for testing
RESTRICT="test"

RDEPEND="
	dev-libs/libzip:=
	dev-libs/xxhash
	sys-apps/file
	sys-libs/zlib
	dev-libs/capstone:0=
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="
	${RDEPEND}
	dev-util/gperf
"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-5.5.0-vector35.patch" )

src_prepare() {
	default

	# Hack for vector35 arm plugins
	mv "${WORKDIR}/vector35-arch-arm64-${ARM64_COMMIT}" libr/asm/arch/arm/v35arm64/arch-arm64 || die
	mv "${WORKDIR}/vector35-arch-armv7-${ARMV7_COMMIT}" libr/asm/arch/arm/v35arm64/arch-armv7 || die

	if use test; then
		cp -r "${WORKDIR}/radare2-testbins-${BINS_COMMIT}" "${S}/test/bins" || die
		cp -r "${WORKDIR}/radare2-testbins-${BINS_COMMIT}" "${S}" || die
	fi

	# Fix hardcoded docdir for fortunes
	sed -i -e "/^#define R2_FORTUNES/s/radare2/$PF/" \
		libr/include/r_userconf.h.acr
}

src_configure() {
	# Ideally these should be set by ./configure
	tc-export CC AR LD OBJCOPY RANLIB
	export HOST_CC=${CC}

	econf \
		--without-libuv \
		--with-syscapstone \
		--with-sysmagic \
		--with-sysxxhash \
		--with-syszip \
		$(use_with ssl openssl)
}

src_install() {
	default

	insinto /usr/share/zsh/site-functions
	doins doc/zsh/_*

	newbashcomp doc/bash_autocompletion.sh "${PN}"
	bashcomp_alias "${PN}" rafind2 r2 rabin2 rasm2 radiff2

	# a workaround for unstable $(INSTALL) call, bug #574866
	local d
	for d in doc/*; do
		if [[ -d ${d} ]]; then
			rm -rfv "${d}" || die "failed to delete '${d}'"
		fi
	done

	# These are not really docs. radare assumes
	# uncompressed files: bug #761250
	docompress -x /usr/share/doc/${PF}/fortunes.{creepy,fun,nsfw,tips}
}

src_test() {
	emake -C test -k unit_tests || die
}
