# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit edo optfeature multiprocessing python-single-r1 toolchain-funcs xdg

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kovidgoyal/kitty.git"
else
	inherit verify-sig
	SRC_URI="
		https://github.com/kovidgoyal/kitty/releases/download/v${PV}/${P}.tar.xz
		verify-sig? ( https://github.com/kovidgoyal/kitty/releases/download/v${PV}/${P}.tar.xz.sig )"
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/kovidgoyal.gpg"
	KEYWORDS="amd64 ~ppc64 ~riscv x86"
fi

DESCRIPTION="Fast, feature-rich, GPU-based terminal"
HOMEPAGE="https://sw.kovidgoyal.net/kitty/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+X test transfer wayland"
REQUIRED_USE="
	|| ( X wayland )
	${PYTHON_REQUIRED_USE}"
RESTRICT="!X? ( test ) !test? ( test ) !transfer? ( test ) !wayland? ( test )"

# dlopen: fontconfig,libglvnd
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/openssl:=
	media-libs/fontconfig
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libglvnd[X?]
	media-libs/libpng:=
	sys-apps/dbus
	sys-libs/zlib:=
	x11-libs/libxkbcommon[X?]
	x11-misc/xkeyboard-config
	~x11-terms/kitty-shell-integration-${PV}
	~x11-terms/kitty-terminfo-${PV}
	X? ( x11-libs/libX11 )
	transfer? ( net-libs/librsync:= )
	wayland? ( dev-libs/wayland )"
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
	sys-libs/ncurses
	virtual/pkgconfig
	test? ( $(python_gen_cond_dep 'dev-python/pillow[${PYTHON_USEDEP}]') )
	wayland? ( dev-util/wayland-scanner )"
[[ ${PV} == 9999 ]] || BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-kovidgoyal )"

src_prepare() {
	default

	# seds unfortunately feel easier on maintainenance than patches here
	sed -e "s/'x11 wayland'/'$(usev X x11) $(usev wayland)'/" \
		-e "$(usev !X '/gl_libs =/s/=.*/= []/')" \
		-e "/num_workers =/s/=.*/= $(makeopts_jobs)/" \
		-e "s/cflags.append.*-O3.*/pass/" -e 's/-O3//' \
		-i setup.py || die

	if use !transfer; then
		sed -i 's/rs_cflag =/& []#/;/files.*rsync/d' setup.py || die
		rm -r kittens/transfer || die
	fi

	# test relies on 'who' command which doesn't detect users with pid-sandbox
	rm kitty_tests/utmp.py || die

	# test may fail/hang depending on environment and shell initialization scripts
	rm kitty_tests/{shell_integration,ssh}.py || die

	# skip docs for live version
	[[ ${PV} != 9999 ]] || sed -i '/exists.*_build/,/docs(ddir)/d' setup.py || die
}

src_compile() {
	tc-export CC
	export PKGCONFIG_EXE=$(tc-getPKG_CONFIG)

	local conf=(
		--disable-link-time-optimization
		--ignore-compiler-warnings
		--libdir-name=$(get_libdir)
		--shell-integration="enabled no-rc"
		--update-check-interval=0
		--verbose
	)

	edo ${EPYTHON} setup.py linux-package "${conf[@]}"
	use test && edo ${EPYTHON} setup.py build-launcher "${conf[@]}"

	[[ ${PV} == 9999 ]] || mv linux-package/share/doc/{${PN},${PF}} || die
	rm -r linux-package/share/terminfo || die
}

src_test() {
	KITTY_CONFIG_DIRECTORY=${T} ./test.py || die # shebang is kitty
}

src_install() {
	insinto /usr
	doins -r linux-package/.

	fperms +x /usr/bin/kitty \
		/usr/$(get_libdir)/kitty/shell-integration/ssh/{askpass.py,kitty}
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "in-terminal image display with kitty icat" media-gfx/imagemagick
	optfeature "audio-based terminal bell support" media-libs/libcanberra
	optfeature "opening links from the terminal" x11-misc/xdg-utils
}
