# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
FINDLIB_USE="ocaml"

inherit findlib eutils multilib toolchain-funcs java-pkg-opt-2 flag-o-matic usr-ldscript \
	autotools udev systemd python-r1

DESCRIPTION="Daemon that provides access to the Linux/Unix console for a blind person"
HOMEPAGE="https://brltty.app/"
SRC_URI="https://brltty.app/archive/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ppc64 x86"
IUSE="+api +beeper bluetooth +contracted-braille doc +fm gpm iconv icu
		java +midi ncurses nls ocaml +pcm python usb +speech
		tcl X"
REQUIRED_USE="doc? ( api )
	java? ( api )
	ocaml? ( api )
	python? ( api ${PYTHON_REQUIRED_USE} )
	tcl? ( api )"

COMMON_DEP="bluetooth? ( net-wireless/bluez )
	gpm? ( >=sys-libs/gpm-1.20 )
	iconv? ( virtual/libiconv )
	icu? ( dev-libs/icu:= )
	python? ( ${PYTHON_DEPS} )
	ncurses? ( sys-libs/ncurses:0= )
	nls? ( virtual/libintl )
	tcl? ( >=dev-lang/tcl-8.4.15:0= )
	usb? ( virtual/libusb:0 )
	X? ( x11-libs/libXaw )"
DEPEND="virtual/pkgconfig
	java? ( >=virtual/jdk-1.4 )
	python? ( >=dev-python/cython-0.16[${PYTHON_USEDEP}] )
	${COMMON_DEP}"
RDEPEND="java? ( >=virtual/jre-1.4 )
	${COMMON_DEP}"

HTML_DOCS=( "${S}"/Documents/Manual-BrlAPI/. )

PATCHES=(
	"${FILESDIR}"/${PN}-5.2-fix-ldflags.patch
	"${FILESDIR}"/${PN}-5.2-udev.patch
	"${FILESDIR}"/${PN}-5.2-respect-AR.patch
	"${FILESDIR}"/${PN}-5.2-sysmacros.patch
)

src_prepare() {
	default

	java-pkg-opt-2_src_prepare

	# The code runs `pkg-config` directly instead of locating a suitable
	# pkg-config wrapper (or respecting $PKG_CONFIG).
	sed -i \
		-e 's/\<pkg-config\>/${PKG_CONFIG:-pkg-config}/' \
		aclocal.m4 configure.ac || die

	# We run eautoconf instead of using eautoreconf because brltty uses
	# a custom build system that uses autoconf without the rest of the
	# autotools.
	eautoconf
	python_copy_sources
}

src_configure() {
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags ncurses)"
	append-libs "$($(tc-getPKG_CONFIG) --libs ncurses)"

	tc-export AR LD PKG_CONFIG
	# override prefix in order to install into /
	# braille terminal needs to be available as soon in the boot process as
	# possible
	# Also override localstatedir so that the lib/brltty directory is installed
	# correctly.
	# Disable stripping since we do that ourselves.
	local myconf=(
		--prefix=/
		--localedir=/usr/share/locale
		--includedir=/usr/include
		--localstatedir=/var
		--disable-stripping
		--with-install-root="${D}"
		--with-writable-directory="/run/brltty"
		$(use_enable api)
		$(use_with beeper beep-package)
		$(use_enable contracted-braille)
		$(use_with fm fm-package)
		$(use_enable gpm)
		$(use_enable iconv)
		$(use_enable icu)
		$(use_enable java java-bindings)
		$(use_with midi midi-package)
		$(use_enable nls i18n)
		$(use_enable ocaml ocaml-bindings)
		$(use_with pcm pcm-package)
		$(use_enable speech speech-support)
		$(use_enable tcl tcl-bindings)
		$(use_enable X x)
		$(use_with bluetooth bluetooth-package)
		$(use_with ncurses curses)
		$(use_with usb usb-package) )

	econf "${myconf[@]}"

	if use python; then
		myconf+=( $(use_enable python python-bindings ) )

		python_configure() {
			econf "${myconf[@]}"
		}
		python_foreach_impl run_in_build_dir python_configure
	fi
}

src_compile() {
	local JAVAC_CONF=""
	local OUR_JNI_FLAGS=""
	if use java; then
		OUR_JNI_FLAGS="$(java-pkg_get-jni-cflags)"
		JAVAC_CONF="${JAVAC} -encoding UTF-8 $(java-pkg_javac-args)"
	fi

	emake JAVA_JNI_FLAGS="${OUR_JNI_FLAGS}" JAVAC="${JAVAC_CONF}"

	if use python; then
		python_build() {
			cd "Bindings/Python" || die
			emake
		}
		python_foreach_impl run_in_build_dir python_build
	fi
}

src_install() {
	if use ocaml; then
		findlib_src_preinst
	fi

	emake OCAML_LDCONF= install

	if use python; then
		python_install() {
			cd "Bindings/Python" || die
			emake install
		}
		python_foreach_impl run_in_build_dir python_install
	fi

	if use java; then
		# make install puts the _java.so there, and no it's not $(get_libdir)
		rm -rf "${D}/usr/lib/java"
		java-pkg_doso Bindings/Java/libbrlapi_java.so
		java-pkg_dojar Bindings/Java/brlapi.jar
	fi

	insinto /etc
	doins Documents/brltty.conf
	udev_newrules Autostart/Udev/udev.rules 70-brltty.rules
	newinitd "${FILESDIR}"/brltty.rc brltty
	systemd_dounit Autostart/Systemd/brltty.service
	systemd_dotmpfilesd "${FILESDIR}/${PN}.tmpfiles.conf"

	libdir="$(get_libdir)"
	mkdir -p "${D}"/usr/${libdir}/
	mv "${D}"/${libdir}/*.a "${D}"/usr/${libdir}/
	gen_usr_ldscript libbrlapi.so

	cd Documents || die
	mv Manual-BRLTTY/English/BRLTTY.txt BRLTTY-en.txt || die
	mv Manual-BRLTTY/French/BRLTTY.txt BRLTTY-fr.txt || die
	mv Manual-BrlAPI/English/BrlAPI.txt BrlAPI-en.txt || die
	dodoc CONTRIBUTORS ChangeLog HISTORY README* TODO BRLTTY-*.txt
	if use doc; then
		dodoc BrlAPI-*.txt
		HTML_DOCS="Manual-BRLTTY" einstalldocs
	fi

	keepdir /var/lib/BrlAPI
	rmdir "${D}/run/brltty" || die
	rmdir "${D}/run" || die
}

pkg_postinst() {
	elog
	elog "please be sure ${ROOT}etc/brltty.conf is correct for your system."
	elog
	elog "To make brltty start on boot, type this command as root:"
	elog
	elog "rc-update add brltty boot"
}
