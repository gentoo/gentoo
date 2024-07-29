# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit edo flag-o-matic go-env optfeature multiprocessing
inherit python-single-r1 toolchain-funcs xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kovidgoyal/kitty.git"
else
	inherit verify-sig
	SRC_URI="
		https://github.com/kovidgoyal/kitty/releases/download/v${PV}/${P}.tar.xz
		https://dev.gentoo.org/~ionen/distfiles/${P}-vendor.tar.xz
		verify-sig? ( https://github.com/kovidgoyal/kitty/releases/download/v${PV}/${P}.tar.xz.sig )
	"
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/kovidgoyal.gpg
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Fast, feature-rich, GPU-based terminal"
HOMEPAGE="https://sw.kovidgoyal.net/kitty/"

LICENSE="GPL-3 ZLIB"
LICENSE+=" Apache-2.0 BSD BSD-2 MIT MPL-2.0" # go
SLOT="0"
IUSE="+X test wayland"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( X wayland )
	test? ( X wayland )
"
RESTRICT="!test? ( test )"

# dlopen: fontconfig,libglvnd
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/openssl:=
	dev-libs/xxhash
	media-fonts/symbols-nerd-font
	media-libs/fontconfig
	media-libs/harfbuzz:=[truetype]
	media-libs/lcms:2
	media-libs/libglvnd[X?]
	media-libs/libpng:=
	sys-apps/dbus
	sys-libs/zlib:=
	x11-libs/libxkbcommon[X?]
	x11-misc/xkeyboard-config
	~x11-terms/kitty-shell-integration-${PV}
	~x11-terms/kitty-terminfo-${PV}
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
	)
	wayland? ( dev-libs/wayland )
	!sci-mathematics/kissat
"
DEPEND="
	${RDEPEND}
	amd64? ( >=dev-libs/simde-0.8.0-r1 )
	arm64? ( dev-libs/simde )
	x86? ( dev-libs/simde )
	X? (
		x11-base/xorg-proto
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
	)
	wayland? ( dev-libs/wayland-protocols )
"
# bug #919751 wrt go subslot
BDEPEND="
	${PYTHON_DEPS}
	>=dev-lang/go-1.22:=
	sys-libs/ncurses
	virtual/pkgconfig
	test? ( $(python_gen_cond_dep 'dev-python/pillow[${PYTHON_USEDEP}]') )
	wayland? ( dev-util/wayland-scanner )
"
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
		-e "s/cflags.append(fortify_source)/pass/" # use toolchain's _f_s
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
	local -x PKGCONFIG_EXE=$(tc-getPKG_CONFIG)

	go-env_set_compile_environment
	local -x GOFLAGS="-p=$(makeopts_jobs) -v -x -buildvcs=false"
	use ppc64 && [[ $(tc-endian) == big ]] || GOFLAGS+=" -buildmode=pie"

	# workaround link errors with Go + gcc + -g3 (bug #924436),
	# retry now and then to see if can be dropped
	tc-is-gcc &&
		CGO_CFLAGS=$(
			CFLAGS=${CGO_CFLAGS}
			replace-flags -g3 -g
			replace-flags -ggdb3 -ggdb
			printf %s "${CFLAGS}"
		)

	local conf=(
		--disable-link-time-optimization
		--ignore-compiler-warnings
		--libdir-name=$(get_libdir)
		--shell-integration="enabled no-rc no-sudo"
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

	# kitty currently detects and copies the system's nerd font at build
	# time, then uses that rather than the system's at runtime
	dosym -r /usr/share/fonts/symbols-nerd-font/SymbolsNerdFontMono-Regular.ttf \
		/usr/"$(get_libdir)"/kitty/fonts/SymbolsNerdFontMono-Regular.ttf
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "audio-based terminal bell support" media-libs/libcanberra
	use X && optfeature "X11 startup notification support" x11-libs/startup-notification
	optfeature "opening links from the terminal" x11-misc/xdg-utils
}
