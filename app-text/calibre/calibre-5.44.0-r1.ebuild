# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="ipv6(+),sqlite,ssl"

inherit toolchain-funcs python-single-r1 qmake-utils xdg-utils

DESCRIPTION="Ebook management application"
HOMEPAGE="https://calibre-ebook.com/"
SRC_URI="https://download.calibre-ebook.com/${PV}/${P}.tar.xz"

LICENSE="
	GPL-3+
	GPL-3
	GPL-2+
	GPL-2
	GPL-1+
	LGPL-3+
	LGPL-2.1+
	LGPL-2.1
	BSD
	MIT
	Old-MIT
	Apache-2.0
	public-domain
	|| ( Artistic GPL-1+ )
	CC-BY-3.0
	OFL-1.1
	PSF-2
"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE="ios +udisks"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=app-text/hunspell-1.7:=
	>=app-text/podofo-0.9.6_pre20171027:=
	>=app-text/poppler-0.26.5[qt5]
	dev-libs/glib:2=
	dev-libs/hyphen:=
	>=dev-libs/icu-57.1:=
	dev-libs/libinput:=
	>=dev-libs/dbus-glib-0.106
	dev-libs/openssl:=
	dev-libs/snowball-stemmer:=
	>=sys-apps/dbus-1.10.8
	$(python_gen_cond_dep '
		app-accessibility/speech-dispatcher[python,${PYTHON_USEDEP}]
		>=dev-python/apsw-3.25.2_p1[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/cchardet[${PYTHON_USEDEP}]
		>=dev-python/chardet-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/cssselect-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/css-parser-1.0.4[${PYTHON_USEDEP}]
		>=dev-python/dbus-python-1.2.4[${PYTHON_USEDEP}]
		dev-python/dnspython[${PYTHON_USEDEP}]
		>=dev-python/feedparser-5.2.1[${PYTHON_USEDEP}]
		>=dev-python/html2text-2019.8.11[${PYTHON_USEDEP}]
		>=dev-python/html5-parser-0.4.9[${PYTHON_USEDEP}]
		dev-python/jeepney[${PYTHON_USEDEP}]
		>=dev-python/lxml-3.8.0[${PYTHON_USEDEP}]
		>=dev-python/markdown-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/mechanize-0.3.5[${PYTHON_USEDEP}]
		>=dev-python/msgpack-0.6.2[${PYTHON_USEDEP}]
		>=dev-python/netifaces-0.10.5[${PYTHON_USEDEP}]
		>=dev-python/pillow-3.2.0[truetype,${PYTHON_USEDEP}]
		>=dev-python/psutil-4.3.0[${PYTHON_USEDEP}]
		>=dev-python/pychm-0.8.6[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.5.3[${PYTHON_USEDEP}]
		dev-python/zeroconf[${PYTHON_USEDEP}]
		>=dev-python/PyQt5-5.15.5_pre2107091435[gui,svg,widgets,network,printsupport,${PYTHON_USEDEP}]
		>=dev-python/PyQt-builder-1.10.3[${PYTHON_USEDEP}]
		>=dev-python/PyQtWebEngine-5.15.5_pre2108100905[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
	')
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtgui:5=[jpeg]
	dev-qt/qtwidgets:5=
	dev-util/desktop-file-utils
	dev-util/gtk-update-icon-cache
	media-fonts/liberation-fonts
	media-libs/fontconfig:=
	>=media-libs/freetype-2:=
	>=media-libs/libmtp-1.1.11:=
	>=media-libs/libwmf-0.2.8
	>=media-gfx/optipng-0.7.6
	>=sys-libs/zlib-1.2.11:=
	virtual/libusb:1=
	x11-libs/libxkbcommon:=
	x11-libs/libX11:=
	x11-libs/libXext:=
	x11-libs/libXrender:=
	x11-misc/shared-mime-info
	>=x11-misc/xdg-utils-1.0.2-r2
	ios? (
		>=app-pda/usbmuxd-1.0.8
		>=app-pda/libimobiledevice-1.2.0
	)
	udisks? ( virtual/libudev )"
RDEPEND="${COMMON_DEPEND}
	udisks? ( sys-fs/udisks:2 )"
DEPEND="${COMMON_DEPEND}"
BDEPEND="$(python_gen_cond_dep '
		>=dev-python/setuptools-23.1.0[${PYTHON_USEDEP}]
		>=dev-python/sip-5[${PYTHON_USEDEP}]
	')
	>=virtual/podofo-build-0.9.6_pre20171027
	virtual/pkgconfig"

PATCHES=(
	# Don't prompt the user for updates - they've installed via
	# an ebuild.
	"${FILESDIR}/${PN}-2.9.0-no_updates_dialog.patch"

	# Skip calling a binary (JxrDecApp) from libjxr which is used for tests
	# We don't (yet?) package libjxr and it seems to be dead upstream
	# (last commit in 2017)
	"${FILESDIR}/${PN}-5.35.0-jxr-test.patch"

	# TODO:
	# test_qt tries to load a bunch of images using Qt and it currently fails
	# due to some presumably missing dependencies. This is important and
	# we need to look into it, but at time of writing, none of the tests
	# are even bring run, so I'd like to return to this later.
	# We don't want to skip test_qt entirely, so just skip this particular
	# assert for now.
	"${FILESDIR}/${PN}-5.31.0-qt-image-test.patch"
)

src_prepare() {
	default

	# Warning:
	#
	# While it might be rather tempting to add yet another sed here,
	# please don't. There have been several bugs in Gentoo's packaging
	# of calibre from seds-which-become-stale. Please consider
	# creating a patch instead, but in any case, run the test suite
	# and ensure it passes.
	#
	# If in doubt about a problem, checking Fedora or Arch Linux's packaging
	# is recommended, as Arch Linux's PKGBUILD is maintained by a Calibre
	# contributor. Or just ask them.

	# Fix outdated version constant.
	#sed -e "s#\\(^numeric_version =\\).*#\\1 (${PV//./, })#" \
	#	-i src/calibre/constants.py || \
	#	die "sed failed to patch constants.py"

	# Avoid sandbox violation in /usr/share/gnome/apps when linux.py
	# calls xdg-* (bug #258938).
	sed -e "s|'xdg-desktop-menu', 'install'|\\0, '--mode', 'user'|" \
		-e "s|check_call(\\['xdg-desktop-menu', 'forceupdate'\\])|#\\0|" \
		-e "s|\\(CurrentDir(tdir)\\), \\\\\$|\\1:|" \
		-e "s|, PreserveMIMEDefaults():|:|" \
		-e "s|'xdg-icon-resource', 'install'|\\0, '--mode', 'user'|" \
		-e "s|cmd\[2\]|cmd[4]|" \
		-e "s|cc(\\['xdg-desktop-menu', 'forceupdate'\\])|#\\0|" \
		-e "s|'xdg-mime', 'install'|\\0, '--mode', 'user'|" \
		-i src/calibre/linux.py || die "sed failed to patch linux.py"

	# Disable unnecessary privilege dropping for bug #287067.
	sed -e "s:if os.geteuid() == 0:if False and os.geteuid() == 0:" \
		-i setup/install.py || die "sed failed to patch install.py"
	sed -e "/^            os.chdir(os.path.join(src_dir, 'build'))$/a\
\\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ self.check_call(['sed', \
'-e', 's|^CFLAGS .*|\\\\\\\\0 ${CFLAGS}|', \
'-e', 's|^CXXFLAGS .*|\\\\\\\\0 ${CXXFLAGS}|', \
'-e', 's|^LFLAGS .*|\\\\\\\\0 ${LDFLAGS}|', \
'-i', os.path.join(os.path.basename(src_dir), 'Makefile')])" \
		-e "s|open(self.j(bdir, '.qmake.conf'), 'wb').close()|open(self.j(bdir, '.qmake.conf'), 'wb').write(b'QMAKE_LFLAGS += ${LDFLAGS}')|" \
		-i setup/build.py || die "sed failed to patch build.py"
}

src_compile() {
	# TODO: get qmake called by setup.py to respect CC and CXX too
	tc-export CC CXX

	# bug 821871
	local MY_LIBDIR="${ESYSROOT}/usr/$(get_libdir)"
	export FT_LIB_DIR="${MY_LIBDIR}" HUNSPELL_LIB_DIR="${MY_LIBDIR}" PODOFO_LIB_DIR="${MY_LIBDIR}"

	PATH="${T}/bin:$(qt5_get_bindir):${PATH}" ${EPYTHON} setup.py build || die
}

src_test() {
	# Skipped tests:
	# - 7z (unpackaged Python dependency: py7zr)
	# - test_unrar (unpackaged Python dependency: unrardll)
	#
	# Note that we currently have a hack to skip one part of test_qt!
	# See PATCHES for more.
	CALIBRE_PY3_PORT=1 ${PYTHON} setup.py test \
			--exclude-test-name 7z \
			--exclude-test-name test_mem_leaks \
			--exclude-test-name test_searching \
			--exclude-test-name test_unrar || die
}

src_install() {
	# calibre works with python 3, so remove the python 2 constraint
	export CALIBRE_PY3_PORT=1

	# Bypass kbuildsycoca and update-mime-database in order to
	# avoid sandbox violations if xdg-mime tries to call them.
	mkdir "${T}/bin" || die
	cat - > "${T}/bin/kbuildsycoca" <<-EOF
	#!${BASH}
	echo $0 : $@
	exit 0
	EOF

	cp "${T}"/bin/{kbuildsycoca,update-mime-database} || die
	chmod +x "${T}"/bin/{kbuildsycoca,update-mime-database} || die

	export QMAKE="$(qt5_get_bindir)/qmake"

	# Unset DISPLAY in order to prevent xdg-mime from triggering a sandbox
	# violation with kbuildsycoca as in bug #287067, comment #13.
	export -n DISPLAY

	# Bug #352625 - Some LANGUAGE values can trigger the following ValueError:
	#   File "/usr/lib/python2.6/locale.py", line 486, in getdefaultlocale
	#    return _parse_localename(localename)
	#  File "/usr/lib/python2.6/locale.py", line 418, in _parse_localename
	#    raise ValueError, 'unknown locale: %s' % localename
	#ValueError: unknown locale: 46
	export -n LANG LANGUAGE ${!LC_*}
	export LC_ALL=C.utf8 #709682

	# Bug #295672 - Avoid sandbox violation in ~/.config by forcing
	# variables to point to our fake temporary $HOME.
	export HOME="${T}/fake_homedir"
	export XDG_CONFIG_HOME="${HOME}/.config"
	export XDG_DATA_HOME="${HOME}/.local/share"
	export CALIBRE_CONFIG_DIRECTORY="${XDG_CONFIG_HOME}/calibre"
	mkdir -p "${XDG_DATA_HOME}" "${CALIBRE_CONFIG_DIRECTORY}" || die

	tc-export CC CXX
	# Bug #334243 - respect LDFLAGS when building extensions
	export OVERRIDE_CFLAGS="$CFLAGS" OVERRIDE_LDFLAGS="$LDFLAGS"
	local libdir=$(get_libdir)
	[[ -n $libdir ]] || die "get_libdir returned an empty string"

	addpredict /dev/dri #665310

	PATH=${T}/bin:${PATH} PYTHONPATH=${S}/src${PYTHONPATH:+:}${PYTHONPATH} \
		"${PYTHON}" setup.py install \
		--root="${D}" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/${libdir}" \
		--staging-root="${ED}/usr" \
		--staging-libdir="${ED}/usr/${libdir}" || die

	find "${ED}"/usr/share -type d -empty -delete

	cd "${ED}"/usr/share/calibre/fonts/liberation || die
	local x
	for x in * ; do
		[[ -f ${EPREFIX}/usr/share/fonts/liberation-fonts/${x} ]] || continue
		ln -sf "../../../fonts/liberation-fonts/${x}" "${x}" || die
	done

	einfo "Converting python shebangs"
	python_fix_shebang --force "${ED}"

	einfo "Compiling python modules"
	python_optimize "${ED}"/usr/$(get_libdir)/calibre "${D}/$(python_get_sitedir)"

	newinitd "${FILESDIR}"/calibre-server-3.init calibre-server
	newconfd "${FILESDIR}"/calibre-server-3.conf calibre-server
}

pkg_preinst() {
	# Indentify stray directories from upstream's "Binary install"
	# method (see bug 622728).
	CALIBRE_LIB_DIR=/usr/$(get_libdir)/calibre
	CALIBRE_LIB_CONTENT=$(for x in "${ED}${CALIBRE_LIB_DIR}"/*; do
		printf -- "${x##*/} "; done) || die "Failed to list ${ED}${CALIBRE_LIB_DIR}"
}

pkg_postinst() {
	[[ -n ${CALIBRE_LIB_DIR} ]] || die "CALIBRE_LIB_DIR is unset"
	local x
	for x in "${EROOT}${CALIBRE_LIB_DIR}"/*; do
		if [[ " ${CALIBRE_LIB_CONTENT} " != *" ${x##*/} "* ]]; then
			elog "Purging '${x}'"
			rm -rf "${x}"
		fi
	done
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
