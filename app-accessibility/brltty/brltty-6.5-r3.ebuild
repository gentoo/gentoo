# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
FINDLIB_USE="ocaml"
JAVA_PKG_WANT_SOURCE="1.8"
JAVA_PKG_WANT_TARGET="1.8"

inherit findlib toolchain-funcs java-pkg-opt-2 autotools python-r1 tmpfiles

DESCRIPTION="Daemon that provides access to the Linux/Unix console for a blind person"
HOMEPAGE="https://brltty.app/"
SRC_URI="https://brltty.app/archive/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~loong ppc ppc64 ~riscv x86"
IUSE="+api +beeper bluetooth doc +fm gpm iconv icu
		java louis +midi ncurses nls ocaml +pcm policykit python
		usb systemd +speech tcl xml X"
REQUIRED_USE="doc? ( api )
	java? ( api )
	ocaml? ( api )
	python? ( api ${PYTHON_REQUIRED_USE} )
	tcl? ( api )"

DEPEND="
	acct-group/brltty
	acct-user/brltty
	dev-libs/libpcre2[pcre32]
	bluetooth? (
		sys-apps/dbus
		net-wireless/bluez
	)
	gpm? ( >=sys-libs/gpm-1.20 )
	iconv? ( virtual/libiconv )
	icu? ( dev-libs/icu:= )
	louis? ( dev-libs/liblouis:= )
	midi? ( media-libs/alsa-lib )
	ncurses? ( sys-libs/ncurses:0= )
	pcm? ( media-libs/alsa-lib )
	policykit? ( sys-auth/polkit )
	python? ( ${PYTHON_DEPS} )
	speech? (
		app-accessibility/espeak-ng
		app-accessibility/flite
		app-accessibility/speech-dispatcher
	)
	systemd? ( sys-apps/systemd )
	tcl? ( >=dev-lang/tcl-8.6.13-r1:= )
	usb? ( virtual/libusb:1 )
	xml? ( dev-libs/expat )
	X? (
		app-accessibility/at-spi2-core:2
		sys-apps/dbus
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXfixes
		x11-libs/libXt
		x11-libs/libXtst
	)"
RDEPEND="${DEPEND}
	java? ( >=virtual/jre-1.8:* )
"
# <cython-3:
# * see https://brltty.app/pipermail/brltty/2023-August/020046.html
# * https://discourse.gnome.org/t/psa-for-distros-brltty-should-be-built-using-cython-0-29-x-not-cython-3/16715
BDEPEND="
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.8:* )
	nls? ( virtual/libintl )
	python? ( <dev-python/cython-3[${PYTHON_USEDEP}] )
"

HTML_DOCS=( "${S}"/Documents/Manual-BrlAPI/. )

PATCHES=(
	"${FILESDIR}"/${PN}-6.4-respect-AR.patch
	"${FILESDIR}"/${PN}-6.5-gettext-0.22.patch
)

src_prepare() {
	default

	java-pkg-opt-2_src_prepare

	# We run eautoconf instead of using eautoreconf because brltty uses
	# a custom build system that uses autoconf without the rest of the
	# autotools.
	eautoconf
	use python && python_copy_sources
}

src_configure() {
	tc-export AR LD PKG_CONFIG

	export JAVAC=""
	export JAVA_JNI_FLAGS=""
	if use java; then
		export JAVA_HOME="$(java-config -g JAVA_HOME)"
		export JAVAC_HOME="${JAVA_HOME}/bin"
		export JAVA_JNI_FLAGS="$(java-pkg_get-jni-cflags)"
		export JAVAC="$(java-pkg_get-javac) -encoding UTF-8 $(java-pkg_javac-args)"
	fi

	# Override bindir for backward compatibility.
	# Also override localstatedir so that the lib/brltty directory is installed
	# correctly.
	# Disable stripping since we do that ourselves.
	local myconf=(
		--bindir="${EPREFIX}"/bin
		--htmldir="${EPREFIX}"/usr/share/doc/"${P}"/html
		--localstatedir="${EPREFIX}"/var
		--runstatedir="${EPREFIX}"/run
		# the next two lines should be removed once support is added.
		--disable-emacs-bindings
		--disable-lua-bindings
		--disable-stripping
		--with-updatable-directory="${EPREFIX}"/var/lib/brltty
		--with-writable-directory="${EPREFIX}"/run/brltty
		--with-privilege-parameters=lx:user=brltty
		$(use_enable api)
		$(use_with beeper beep-package)
#		$(use_enable emacs emacs-bindings)
		$(use_with fm fm-package)
		$(use_enable gpm)
		$(use_enable iconv)
		$(use_enable icu)
		$(use_enable java java-bindings)
		$(use_enable louis liblouis)
#		$(use_enable lua lua-bindings)
		$(use_with midi midi-package)
		$(use_enable nls i18n)
		$(use_enable ocaml ocaml-bindings)
		$(use_with pcm pcm-package)
		$(use_enable policykit polkit)
		$(use_enable python python-bindings)
		$(use_enable speech speech-support)
		$(use_with systemd service-package)
		$(use_enable tcl tcl-bindings)
		$(use_enable xml expat)
		$(use_enable X x)
		$(use_with bluetooth bluetooth-package)
		$(use_with ncurses curses)
		$(use_with usb usb-package)
	)
	# disable espeak since we use espeak-ng
	use speech && myconf+=( --with-speech-driver=-es )

	econf "${myconf[@]}"

	if use python; then
		python_configure() {
			econf "${myconf[@]}"
		}
		python_foreach_impl run_in_build_dir python_configure
	fi
}

src_compile() {
	emake -j1 JAVA_JNI_FLAGS="${JAVA_JNI_FLAGS}" JAVAC="${JAVAC}"

	if use python; then
		python_build() {
			cd "Bindings/Python" || die
			emake -j1
		}
		python_foreach_impl run_in_build_dir python_build
	fi
}

src_install() {
	if use ocaml; then
		findlib_src_preinst
	fi

	emake -j1 INSTALL_ROOT="${D}" OCAML_LDCONF= install

	if use python; then
		python_install() {
			cd "Bindings/Python" || die
			emake -j1 INSTALL_ROOT="${D}" install
		}
		python_foreach_impl run_in_build_dir python_install
	fi

	if use java; then
		java-pkg_doso Bindings/Java/libbrlapi_java.so
		java-pkg_dojar Bindings/Java/brlapi.jar
	fi

	insinto /etc
	doins Documents/brltty.conf
	newinitd "${FILESDIR}"/brltty.initd brltty
	pushd Autostart/Systemd 1> /dev/null || die
	emake -j1 INSTALL_ROOT="${ED}" install
	popd || die
	pushd Autostart/Udev 1> /dev/null || die
	emake -j1 INSTALL_ROOT="${ED}" install
	popd || die

	dodoc Documents/{CONTRIBUTORS,ChangeLog,HISTORY,README*,TODO}
	if use doc; then
		HTML_DOCS="doc/Manual-BRLTTY" einstalldocs
	fi

	keepdir /var/lib/BrlAPI
	rm -fr "${ED}/run" || die
	find "${ED}" -name '*.a' -delete || die
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf

	elog "please be sure ${EROOT}/etc/brltty.conf is correct for your system."
	elog
	elog "To make brltty start on boot on an OpenRC system, type this command:"
	elog "# rc-update add brltty boot"
	elog
	elog "If you are using systemd, type this command:"
	elog "# systemctl daemon-reload"
	elog
	elog "Please reload udev by typing:"
	elog "# udevadm control --reload"
}
