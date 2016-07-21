# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite,ssl"

inherit eutils fdo-mime bash-completion-r1 multilib toolchain-funcs python-single-r1

DESCRIPTION="Ebook management application"
HOMEPAGE="http://calibre-ebook.com/"
SRC_URI="http://download.calibre-ebook.com/${PV}/${P}.tar.xz"

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
	unRAR
"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE="+udisks"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=app-text/podofo-0.8.2:=
	>=app-text/poppler-0.26.5[qt5]
	>=dev-libs/chmlib-0.40:=
	dev-libs/glib:2
	>=dev-libs/icu-4.4:=
	>=dev-python/apsw-3.7.17[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-3.0.5:python-2[${PYTHON_USEDEP}]
	>=dev-python/cssselect-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/cssutils-0.9.9[${PYTHON_USEDEP}]
	>=dev-python/dbus-python-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.2.1[${PYTHON_USEDEP}]
	>=dev-python/mechanize-0.1.11[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.3.1[gui,svg,webkit,widgets,network,printsupport,${PYTHON_USEDEP}]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-fonts/liberation-fonts
	>=media-gfx/imagemagick-6.5.9[jpeg,png]
	media-libs/fontconfig
	>=media-libs/freetype-2:=
	>=media-libs/libmtp-1.1.5:=
	>=media-libs/libwmf-0.2.8
	sys-libs/zlib
	virtual/libusb:1=
	virtual/python-dnspython[${PYTHON_USEDEP}]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	>=x11-misc/xdg-utils-1.0.2-r2
	udisks? ( virtual/libudev )"
RDEPEND="${COMMON_DEPEND}
	udisks? ( || ( sys-fs/udisks:2 sys-fs/udisks:0 ) )"
DEPEND="${COMMON_DEPEND}
	>=dev-python/setuptools-0.6_rc5[${PYTHON_USEDEP}]
	>=virtual/podofo-build-0.8.2
	virtual/pkgconfig"

src_prepare() {
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

	sed -e "/^            self\\.check_call(qmc + \\[.*\\.pro'\\])$/a\
\\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ self.check_call(['sed', \
'-e', 's|^CFLAGS .*|\\\\\\\\0 ${CFLAGS}|', \
'-e', 's|^CXXFLAGS .*|\\\\\\\\0 ${CXXFLAGS}|', \
'-e', 's|^LFLAGS .*|\\\\\\\\0 ${LDFLAGS}|', \
'-i', 'Makefile'])" \
		-i setup/extensions.py || die "sed failed to patch extensions.py"

	# use system beautifulsoup, instead of bundled
	rm -f "${S}"/src/calibre/ebooks/BeautifulSoup.py \
		|| die "could not remove bundled beautifulsoup"
	find "${S}" -type f -name \*.py -exec \
		sed -e 's/calibre.ebooks.BeautifulSoup/BeautifulSoup/' -i {} + \
		|| die "could not sed bundled beautifulsoup out of the source tree"

	# avoid failure of xdg tools to recognize vendor prefix
	sed -e "s|xdg-icon-resource install|xdg-icon-resource install --novendor|" \
		-e "s|'xdg-mime', 'install'|'xdg-mime', 'install', '--novendor'|" \
		-e "s|'xdg-desktop-menu', 'install'|'xdg-desktop-menu', 'install', '--novendor'|" \
		-i "${S}"/src/calibre/linux.py || die 'sed failed'

	# no_updates: do not annoy user with "new version is availible all the time
	# disable_plugins: walking sec-hole, wait for upstream to use GHNS interface
	epatch \
		"${FILESDIR}/${PN}-2.9.0-no_updates_dialog.patch" \
		"${FILESDIR}/${PN}-disable_plugins.patch"
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
	export -n LANGUAGE

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

	# Bug #472690 - Avoid sandbox violation for /dev/dri/card0.
	local x
	for x in /dev/dri/card[0-9] ; do
		[[ -e ${x} ]] && addpredict ${x}
	done

	#dodir "/usr/$(get_libdir)/python2.7/site-packages" # for init_calibre.py
	#dodir $(python_get_sitedir)
	PATH=${T}:${PATH} PYTHONPATH=${S}/src${PYTHONPATH:+:}${PYTHONPATH} \
	"${PYTHON}" setup.py install \
		--root="${D}" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/${libdir}" \
		--staging-root="${ED}usr" \
		--staging-libdir="${ED}usr/${libdir}" || die

	grep -rlZ "${ED}" "${ED}" | xargs -0 sed -e "s:${D}:/:g" -i ||
		die "failed to fix harcoded \$D in paths"

	# The menu entries end up here due to '--mode user' being added to
	# xdg-* options in src_prepare.
	dodir /usr/share/mime/packages
	chmod -fR a+rX,u+w,g-w,o-w "${HOME}"/.local
	mv "${HOME}"/.local/share/mime/packages/* "${ED}"usr/share/mime/packages/ ||
		die "failed to register mime types"
	dodir /usr/share/icons
	mv "${HOME}"/.local/share/icons/* "${ED}"usr/share/icons/ ||
		die "failed to install icon files"

	domenu "${HOME}"/.local/share/applications/*.desktop ||
		die "failed to install .desktop menu files"

	find "${ED}"usr/share -type d -empty -delete

	cd "${ED}"/usr/share/calibre/fonts/liberation || die
	local x
	for x in * ; do
		[[ -f ${EPREFIX}usr/share/fonts/liberation-fonts/${x} ]] || continue
		ln -sf "../../../fonts/liberation-fonts/${x}" "${x}" || die
	done

	einfo "Converting python shebangs"
	python_fix_shebang "${ED}"

	einfo "Compiling python modules"
	python_optimize "${ED}"usr/lib/calibre

	newinitd "${FILESDIR}"/calibre-server.init calibre-server
	newconfd "${FILESDIR}"/calibre-server.conf calibre-server

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

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
