# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit edo optfeature multiprocessing python-single-r1 toolchain-funcs xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kovidgoyal/kitty.git"
else
	inherit verify-sig
	SRC_URI="
		https://github.com/kovidgoyal/kitty/releases/download/v${PV}/${P}.tar.xz
		https://dev.gentoo.org/~ionen/distfiles/${P}-vendor.tar.xz
		verify-sig? ( https://github.com/kovidgoyal/kitty/releases/download/v${PV}/${P}.tar.xz.sig )"
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/kovidgoyal.gpg"
	KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"
fi

DESCRIPTION="Fast, feature-rich, GPU-based terminal"
HOMEPAGE="https://sw.kovidgoyal.net/kitty/"

LICENSE="GPL-3 ZLIB"
LICENSE+=" Apache-2.0 BSD MIT MPL-2.0" # go
SLOT="0"
IUSE="+X test wayland"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( X wayland )
	test? ( X wayland )"
RESTRICT="!test? ( test )"

# dlopen: fontconfig,libglvnd
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/openssl:=
	media-libs/fontconfig
	media-libs/harfbuzz:=[truetype]
	media-libs/lcms:2
	media-libs/libglvnd[X?]
	media-libs/libpng:=
	net-libs/librsync:=
	sys-apps/dbus
	sys-libs/zlib:=
	x11-libs/libxkbcommon[X?]
	x11-misc/xkeyboard-config
	~x11-terms/kitty-shell-integration-${PV}
	~x11-terms/kitty-terminfo-${PV}
	X? ( x11-libs/libX11 )
	wayland? ( dev-libs/wayland )
	!sci-mathematics/kissat"
DEPEND="
	${RDEPEND}
	X? (
		x11-base/xorg-proto
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
	)
	wayland? ( dev-libs/wayland-protocols )"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-lang/go-1.20
	sys-libs/ncurses
	virtual/pkgconfig
	test? ( $(python_gen_cond_dep 'dev-python/pillow[${PYTHON_USEDEP}]') )
	wayland? ( dev-util/wayland-scanner )"
[[ ${PV} == 9999 ]] || BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-kovidgoyal )"

QA_FLAGS_IGNORED="usr/bin/kitten" # written in Go

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
		cd "${S}" || die
		edo go mod vendor
	else
		use verify-sig &&
			verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.sig}
		default
	fi
}

src_prepare() {
	default

	# sed unfortunately feels easier on maintenance than patches here
	local sedargs=(
		-e "/num_workers =/s/=.*/= $(makeopts_jobs)/"
		-e "s/cflags.append.*-O3.*/pass/" -e 's/-O3//'
		-e "s/ld_flags.append('-[sw]')/pass/"
	)

	# kitty is often popular on wayland-only setups, try to allow this
	use !X && sedargs+=( -e '/gl_libs =/s/=.*/= []/' ) #857918
	use !X || use !wayland &&
		sedargs+=( -e "s/'x11 wayland'/'$(usex X x11 wayland)'/" )

	# skip docs for live version, missing dependencies
	[[ ${PV} == 9999 ]] && sedargs+=( -e '/exists.*_build/,/docs(ddir)/d' )

	sed -i setup.py "${sedargs[@]}" || die

	local skiptests=(
		# relies on 'who' command which doesn't detect users with pid-sandbox
		kitty_tests/utmp.py
		# may fail/hang depending on environment and shell initialization
		kitty_tests/{shell_integration,ssh}.py
		# relies on /proc/self/fd and gets confused when ran from here
		tools/utils/tpmfile_test.go
	)
	use !test || rm "${skiptests[@]}" || die
}

src_compile() {
	tc-export CC
	local -x GOFLAGS="-p=$(makeopts_jobs) -v -x"
	use ppc64 && [[ $(tc-endian) == big ]] || GOFLAGS+=" -buildmode=pie"
	local -x PKGCONFIG_EXE=$(tc-getPKG_CONFIG)

	local conf=(
		--disable-link-time-optimization
		--ignore-compiler-warnings
		--libdir-name=$(get_libdir)
		--shell-integration="enabled no-rc"
		--update-check-interval=0
		--verbose
	)

	edo "${EPYTHON}" setup.py linux-package "${conf[@]}"
	use test && edo "${EPYTHON}" setup.py build-launcher "${conf[@]}"

	rm -r linux-package/share/terminfo || die # provided by kitty-terminfo

	if [[ ${PV} == 9999 ]]; then
		mkdir -p linux-package/share/doc/${PF} || die
	else
		mv linux-package/share/doc/{${PN},${PF}} || die
	fi

	# generate default config as reference, command taken from docs/conf.rst
	if ! tc-is-cross-compiler; then
		linux-package/bin/kitty +runpy \
			'from kitty.config import *; print(commented_out_default_config())' \
			> linux-package/share/doc/${PF}/kitty.conf || die
	fi
}

src_test() {
	KITTY_CONFIG_DIRECTORY=${T} ./test.py || die # shebang is kitty
}

src_install() {
	edo mv linux-package "${ED}"/usr
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "audio-based terminal bell support" media-libs/libcanberra
	optfeature "opening links from the terminal" x11-misc/xdg-utils
}
