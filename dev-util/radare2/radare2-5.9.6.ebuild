# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

DESCRIPTION="unix-like reverse engineering framework and commandline tools"
HOMEPAGE="https://www.radare.org"

ARM64_COMMIT=55d73c6bbb94448a5c615933179e73ac618cf876
ARMV7_COMMIT=f270a6cc99644cb8e76055b6fa632b25abd26024
BINS_COMMIT=87ab82cc96e83e02f044c0c4111ade2a65576c60

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/radareorg/radare2"
else
	SRC_URI="mirror+https://github.com/radareorg/radare2/archive/${PV}.tar.gz -> ${P}.tar.gz
		mirror+https://github.com/radareorg/vector35-arch-arm64/archive/${ARM64_COMMIT}.tar.gz -> ${P}-vector35-arm64.tar.gz
		mirror+https://github.com/radareorg/vector35-arch-armv7/archive/${ARMV7_COMMIT}.tar.gz -> ${P}-vector35-armv7.tar.gz
		test? ( https://github.com/radareorg/radare2-testbins/archive/${BINS_COMMIT}.tar.gz -> radare2-testbins-${BINS_COMMIT}.tar.gz )
	"

	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="ssl test"

# Need to audit licenses of the binaries used for testing
RESTRICT="fetch !test? ( test )"

RDEPEND="
	app-arch/lz4
	>=dev-libs/capstone-5.0_rc4:=
	dev-libs/libzip:=
	dev-libs/xxhash
	sys-apps/file
	sys-libs/zlib
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="
	${RDEPEND}
	dev-util/gperf
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-5.8.2-vector35.patch"
	"${FILESDIR}/${PN}-5.8.4-test.patch"
)

src_prepare() {
	default

	# Hack for vector35 arm plugins
	mv "${WORKDIR}/vector35-arch-arm64-${ARM64_COMMIT}" libr/arch/p/arm/v35/arch-arm64 || die
	mv "${WORKDIR}/vector35-arch-armv7-${ARMV7_COMMIT}" libr/arch/p/arm/v35/arch-armv7 || die

	if use test; then
		cp -r "${WORKDIR}/radare2-testbins-${BINS_COMMIT}" "${S}/test/bins" || die
		cp -r "${WORKDIR}/radare2-testbins-${BINS_COMMIT}" "${S}" || die
	fi

	# Fix hardcoded docdir for fortunes
	sed -i -e "/^#define R2_FORTUNES/s/radare2/$PF/" \
		libr/include/r_userconf.h.acr || die
}

src_configure() {
	# Ideally these should be set by ./configure
	tc-export CC AR LD OBJCOPY RANLIB
	export HOST_CC=${CC}

	econf \
		--with-syscapstone \
		--with-syslz4 \
		--with-sysmagic \
		--with-sysxxhash \
		--with-syszip \
		$(use_with ssl)
}

src_test() {
	ln -fs "${S}/binr/radare2/radare2" "${S}/binr/radare2/r2" || die
	LDFLAGS=""
	for i in "${S}"/libr/*; do
		if [[ -d ${i} ]]; then
			LDFLAGS+="-Wl,-rpath=${i} -L${i} "
			LD_LIBRARY_PATH+=":${i}"
		fi
	done
	export LDFLAGS LD_LIBRARY_PATH
	export PKG_CONFIG_PATH="${S}/pkgcfg"
	PATH="${S}/binr/radare2:${PATH}" emake -C test -k unit-tests || die
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

	# Create plugins directory although it's currently unsupported by radare2
	keepdir "/usr/$(get_libdir)/radare2/${PV}" || die
}
