# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite,ssl"

inherit bash-completion-r1 desktop toolchain-funcs python-single-r1 xdg-utils

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
KEYWORDS="amd64 ~arm x86"
SLOT="0"
IUSE="ios +udisks"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=app-text/podofo-0.9.6_pre20171027:=
	>=app-text/poppler-0.26.5[qt5]
	>=dev-libs/chmlib-0.40:=
	dev-libs/glib:2=
	>=dev-libs/icu-57.1:=
	dev-libs/libinput:=
	>=dev-python/apsw-3.25.2_p1[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.3[${PYTHON_USEDEP}]
	>=dev-python/cssselect-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/css-parser-1.0.4[${PYTHON_USEDEP}]
	>=dev-python/dbus-python-1.2.4[${PYTHON_USEDEP}]
	>=dev-libs/dbus-glib-0.106
	>=sys-apps/dbus-1.10.8
	dev-python/dnspython[${PYTHON_USEDEP}]
	>=dev-python/feedparser-5.2.1[${PYTHON_USEDEP}]
	>=dev-python/html5-parser-0.4.9[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/mechanize-0.3.5[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.5.6[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.10.5[${PYTHON_USEDEP}]
	>=dev-python/pillow-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.3[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.8[gui,svg,webkit,widgets,network,printsupport,${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtgui:5=
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
	udisks? ( || ( sys-fs/udisks:2 sys-fs/udisks:0 ) )"
DEPEND="${COMMON_DEPEND}
	>=dev-python/setuptools-23.1.0[${PYTHON_USEDEP}]
	dev-python/sip[${PYTHON_USEDEP}]
	>=virtual/podofo-build-0.9.6_pre20171027
	virtual/pkgconfig"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary && $(gcc-major-version) -lt 6 ]]; then
		eerror "Calibre cannot be built with this version of gcc."
		eerror "You need at least gcc-6.0"
		die "Your C compiler is too old for this package."
	fi
}

src_prepare() {
	# no_updates: do not annoy user with "new version is availible all the time
	# disable_plugins: walking sec-hole, wait for upstream to use GHNS interface
	eapply \
		"${FILESDIR}/${PN}-2.9.0-no_updates_dialog.patch" \
		"${FILESDIR}/${PN}-disable_plugins.patch"

	eapply_user

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

	sed -e "/^                self.check_call(\\[QMAKE\\] + qmc + \\[proname\\])$/a\
\\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ self.check_call(['sed', \
'-e', 's|^CFLAGS .*|\\\\\\\\0 ${CFLAGS}|', \
'-e', 's|^CXXFLAGS .*|\\\\\\\\0 ${CXXFLAGS}|', \
'-e', 's|^LFLAGS .*|\\\\\\\\0 ${LDFLAGS}|', \
'-i', 'Makefile'])" \
		-i setup/build.py || die "sed failed to patch build.py"
}

src_install() {
	# Bypass kbuildsycoca and update-mime-database in order to
	# avoid sandbox violations if xdg-mime tries to call them.
	cat - > "${T}/kbuildsycoca" <<-EOF
	#!${BASH}
	echo $0 : $@
	exit 0
	EOF

	cp "${T}"/{kbuildsycoca,update-mime-database} || die
	chmod +x "${T}"/{kbuildsycoca,update-mime-database} || die

	export QMAKE="${EPREFIX}/usr/$(get_libdir)/qt5/bin/qmake"

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
	export LC_ALL=C #684484

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

	PATH=${T}:${PATH} PYTHONPATH=${S}/src${PYTHONPATH:+:}${PYTHONPATH} \
	"${PYTHON}" setup.py install \
		--root="${D}" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/${libdir}" \
		--staging-root="${ED}/usr" \
		--staging-libdir="${ED}/usr/${libdir}" || die

	rm "${ED}/usr/share/applications/defaults.list" || die
	find "${ED}"/usr/share -type d -empty -delete

	cd "${ED}"/usr/share/calibre/fonts/liberation || die
	local x
	for x in * ; do
		[[ -f ${EPREFIX}usr/share/fonts/liberation-fonts/${x} ]] || continue
		ln -sf "../../../fonts/liberation-fonts/${x}" "${x}" || die
	done

	einfo "Converting python shebangs"
	python_fix_shebang --force "${ED}"

	einfo "Compiling python modules"
	python_optimize "${ED}"/usr/lib/calibre

	newinitd "${FILESDIR}"/calibre-server-3.init calibre-server
	newconfd "${FILESDIR}"/calibre-server-3.conf calibre-server

	bashcomp_alias calibre \
		lrfviewer \
		calibre-debug \
		ebook-meta \
		calibre-server \
		ebook-viewer \
		ebook-polish \
		fetch-ebook-metadata \
		lrf2lrs \
		ebook-convert \
		ebook-edit \
		calibre-smtp \
		ebook-device

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
