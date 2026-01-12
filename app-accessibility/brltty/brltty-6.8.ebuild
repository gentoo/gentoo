# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FINDLIB_USE="ocaml"
JAVA_PKG_WANT_SOURCE="1.8"
JAVA_PKG_WANT_TARGET="1.8"
LUA_COMPAT=( lua5-4 )
PYTHON_COMPAT=( python3_{11..14} )

inherit autotools elisp-common findlib java-pkg-opt-2 linux-info lua-single python-r1 tmpfiles toolchain-funcs udev

DESCRIPTION="Daemon that provides access to the Linux/Unix console for a blind person"
HOMEPAGE="https://brltty.app/"
SRC_URI="https://brltty.app/archive/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
BINDINGS="emacs java lua ocaml python tcl"
IUSE="+api +beeper bluetooth caps +fm gpm +hid iconv icu louis +midi
ncurses nls +pcm policykit +pcre usb systemd +speech xml X ${BINDINGS}"
REQUIRED_USE="
	emacs? ( api )
	java? ( api )
	lua? ( api ${LUA_REQUIRED_USE} )
	ocaml? ( api )
	policykit? ( api )
	python? ( api ${PYTHON_REQUIRED_USE} )
	tcl? ( api )
"

COMMON_DEPEND="
	acct-group/brltty
	acct-user/brltty
	bluetooth? (
		net-wireless/bluez:=
		sys-apps/dbus
	)
	caps? ( sys-libs/libcap )
	emacs? ( app-editors/emacs:* )
	gpm? ( >=sys-libs/gpm-1.20 )
	hid? ( virtual/libudev:= )
	iconv? ( virtual/libiconv )
	icu? ( dev-libs/icu:= )
	louis? ( dev-libs/liblouis:= )
	midi? ( media-libs/alsa-lib )
	ncurses? ( sys-libs/ncurses:0= )
	lua? ( ${LUA_DEPS} )
	pcm? ( media-libs/alsa-lib )
	pcre? ( dev-libs/libpcre2:=[pcre32] )
	policykit? (
		dev-libs/glib:2
		sys-auth/polkit
	)
	python? (
		${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
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
		dev-libs/glib:2
		sys-apps/dbus
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXfixes
		x11-libs/libXt
		api? ( x11-libs/libXtst )
	)
"
DEPEND="
	${COMMON_DEPEND}
	hid? ( sys-kernel/linux-headers )
	java? ( >=virtual/jdk-1.8:* )
	X? ( x11-base/xorg-proto )
"
RDEPEND="
	${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )
"
BDEPEND="
	>=dev-lang/tcl-8.6.13-r1
	virtual/pkgconfig
	nls? ( virtual/libintl )
	python? ( dev-python/cython[${PYTHON_USEDEP}] )
"

CONFIG_CHECK="
	~INPUT_UINPUT
	~INPUT_PCSPKR
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.4-respect-AR.patch
	"${FILESDIR}"/${PN}-6.8-atspi2_optional.patch
)

pkg_setup() {
	linux-info_pkg_setup

	# bindings
	java-pkg-opt-2_pkg_setup
	use lua && lua-single_pkg_setup
	use python && python_setup
}

src_prepare() {
	default

	# api-socket-api is not defined/used if api is not enabled, see bug #878203
	if ! use api; then
		sed -e '/^d @BRLAPI_SOCKETPATH@/s/^/#/' \
			-i Autostart/Systemd/tmpfiles.in || die
	fi

	java-pkg-opt-2_src_prepare

	# We run eautoconf instead of using eautoreconf because brltty uses
	# a custom build system that uses autoconf without the rest of the
	# autotools.
	eautoconf
	use python && python_copy_sources
}

src_configure() {
	tc-export AR PKG_CONFIG

	export JAVAC=
	export JAVA_JNI_FLAGS=
	if use java; then
		export JAVA_HOME="$(java-config -g JAVA_HOME)"
		export JAVAC_HOME="${JAVA_HOME}/bin"
		export JAVA_JNI_FLAGS="$(java-pkg_get-jni-cflags)"
		export JAVAC="$(java-pkg_get-javac) -encoding UTF-8 $(java-pkg_javac-args)"
	fi

	# see bug #830239, '-n' arg not handled by musl
	export brltty_cv_prog_conflibdir="ldconfig"

	# Override bindir for backward compatibility.
	# Also override localstatedir so that the lib/brltty directory is installed
	# correctly.
	# Disable stripping since we do that ourselves.
	local myconf=(
		--bindir="${EPREFIX}"/bin
		--htmldir="${EPREFIX}"/usr/share/doc/"${PF}"/html
		--localstatedir="${EPREFIX}"/var
		--runstatedir="${EPREFIX}"/run
		# Python bindings are built separately per-impl
		--disable-python-bindings
		--disable-stripping
		--with-updatable-directory="${EPREFIX}"/var/lib/brltty
		--with-writable-directory="${EPREFIX}"/run/brltty
		--with-privilege-parameters=lx:user=brltty
		$(use_enable api)
		$(use_with beeper beep-package)
		$(use_with caps pgmprivs-package)
		$(use_enable emacs emacs-bindings)
		$(use_with fm fm-package)
		$(use_enable gpm)
		$(use_with hid hid-package)
		$(use_enable iconv)
		$(use_enable icu)
		$(use_enable java java-bindings)
		$(use_enable louis liblouis)
		$(use_enable lua lua-bindings)
		$(use_with midi midi-package)
		$(use_enable nls i18n)
		$(use_enable ocaml ocaml-bindings)
		$(use_with pcm pcm-package)
		$(use_enable policykit polkit)
		$(use_with pcre rgx-package)
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
			econf "${myconf[@]}" --enable-python-bindings PYTHON="${PYTHON}"
		}
		python_foreach_impl run_in_build_dir python_configure
	fi
}

src_compile() {
	emake -j1 JAVA_JNI_FLAGS="${JAVA_JNI_FLAGS}" JAVAC="${JAVAC}"

	use emacs && elisp-compile Bindings/Emacs/add_directory.el

	if use python; then
		python_build() {
			emake -C "${BUILD_DIR}"/Bindings/Python -j1
		}
		python_foreach_impl run_in_build_dir python_build
	fi
}

src_install() {
	use ocaml && findlib_src_preinst

	# install-extras for locales, metainfo, polkit rules, systemd-files, udev rules
	emake -j1 INSTALL_ROOT="${D}" OCAML_LDCONF= install install-extras

	use emacs && elisp-install ${PN} Bindings/Emacs/add_directory.el{,c}

	if use python; then
		python_install() {
			emake -C "${BUILD_DIR}"/Bindings/Python -j1 INSTALL_ROOT="${D}" install
			rm -r "${D}/$(python_get_sitedir)"/*.egg-info || die
		}
		python_foreach_impl run_in_build_dir python_install
	fi

	if use java; then
		java-pkg_doso Bindings/Java/libbrlapi_java.so
		java-pkg_dojar Bindings/Java/brlapi.jar
	fi

	insinto /etc
	doins Documents/brltty.conf
	newinitd "${FILESDIR}"/brltty.initd-r1 brltty

	local DOCS=( Documents/{CONTRIBUTORS,ChangeLog,HISTORY,README*,TODO} doc/Manual-BRLTTY )
	local HTML_DOCS=( doc/*.html )
	use api && DOCS+=( Documents/Manual-BrlAPI/English/BrlAPI.sgml )
	einstalldocs

	keepdir /var/lib/BrlAPI
	rm -fr "${ED}/run" || die
	find "${ED}" -name '*.a' -delete || die
}

pkg_postinst() {
	use emacs && elisp-site-regen

	tmpfiles_process ${PN}.conf

	udev_reload

	elog "please be sure ${EROOT}/etc/brltty.conf is correct for your system."
	elog
	if use systemd; then
		elog "To make brltty start on boot on systemd system, type these commands:"
		elog "# systemctl daemon-reload"
		elog "# systemctl enable brltty.path"
		elog "To launch manually:"
		elog "# systemctl start brltty.path"
		elog "Don't try brltty.service"
	else
		elog "To make brltty start on boot on an OpenRC system, type this command:"
		elog "# rc-update add brltty boot"
		elog "To launch manually:"
		elog "# rc-service brltty start"
	fi

	if use caps; then
		elog "To launch brltty as an unprivileged user, please refer to:"
		elog "${EROOT}/usr/share/doc/${PF}/README.Linux#Assigning Capabilities to the Executable"
	fi
}

pkg_postrm() {
	udev_reload
}
