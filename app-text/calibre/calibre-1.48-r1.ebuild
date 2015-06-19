# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/calibre/calibre-1.48-r1.ebuild,v 1.3 2015/02/12 07:26:43 yngwin Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite,ssl"

inherit bash-completion-r1 distutils-r1 eutils fdo-mime multilib toolchain-funcs

DESCRIPTION="Ebook management application"
HOMEPAGE="http://calibre-ebook.com/"
[[ ${PV} == ${PV%.*}.${PV#*.} ]] && MY_PV=${PV}.0 || MY_PV=${PV}
SRC_URI="http://sourceforge.net/projects/calibre/files/${MY_PV}/${PN}-${MY_PV}.tar.xz"

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

COMMON_DEPEND="
	>=app-text/podofo-0.8.2:=
	>=app-text/poppler-0.20.2:=[qt4,xpdf-headers(+)]
	>=dev-libs/chmlib-0.40:=
	>=dev-libs/icu-4.4:=
	>=dev-python/apsw-3.7.17[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-3.0.5:python-2[${PYTHON_USEDEP}]
	>=dev-python/cssselect-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/cssutils-0.9.9[${PYTHON_USEDEP}]
	>=dev-python/dbus-python-0.82.2[${PYTHON_USEDEP}]
	>=dev-python/dnspython-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.2.1[${PYTHON_USEDEP}]
	>=dev-python/mechanize-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-1.4.1[${PYTHON_USEDEP}]
	<dev-python/PyQt4-4.11.3[X,svg,webkit,${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-qt/qtdbus:4=
	dev-qt/qtsvg:4=
	media-fonts/liberation-fonts
	>=media-gfx/imagemagick-6.5.9[jpeg,png]
	>=media-libs/freetype-2:=
	>=media-libs/libwmf-0.2.8
	>=media-libs/libmtp-1.1.5:=
	virtual/libusb:1=
	virtual/python-imaging[${PYTHON_USEDEP}]
	>=x11-misc/xdg-utils-1.0.2-r2"

RDEPEND="${COMMON_DEPEND}
	udisks? ( || ( sys-fs/udisks:2 sys-fs/udisks:0 ) )"

DEPEND="${COMMON_DEPEND}
	>=dev-python/setuptools-0.6_rc5[${PYTHON_USEDEP}]
	>=virtual/podofo-build-0.8.2"

S="${WORKDIR}"/${PN}

PATCHES=(
	# no_updates: do not annoy user with "new version is availible all the time
	# disable_plugins: walking sec-hole, wait for upstream to use GHNS interface
	# C locale: if LC_ALL=C do not raise an exception when locale cannot be canonicalized
	"${FILESDIR}"/${PN}-1.34-no_updates_dialog.patch
	"${FILESDIR}"/${PN}-disable_plugins.patch
	)

export_xdg_dirs() {
	# Bug #295672 - Avoid sandbox violation in ~/.config by forcing
	# variables to point to our fake temporary $HOME.
	export HOME="${T}/fake_homedir"
	export XDG_CONFIG_HOME="${HOME}/.config"
	export XDG_DATA_HOME="${HOME}/.local/share"
	export CALIBRE_CONFIG_DIRECTORY="${XDG_CONFIG_HOME}/calibre"
}

python_prepare_all() {
	# Fix outdated version constant.
	#sed -e "s#\\(^numeric_version =\\).*#\\1 (${PV//./, })#" \
	#	-i src/calibre/constants.py || \
	#	die "sed failed to patch constants.py"

	# Avoid sandbox violation in /usr/share/gnome/apps when linux.py
	# calls xdg-* (bug #258938).
	sed \
		-e "s|'xdg-desktop-menu', 'install'|\\0, '--mode', 'user'|" \
		-e "s|check_call(\\['xdg-desktop-menu', 'forceupdate'\\])|#\\0|" \
		-e "s|\\(CurrentDir(tdir)\\), \\\\\$|\\1:|" \
		-e "s|PreserveMIMEDefaults():||" \
		-e "s|xdg-icon-resource install|\\0 --mode user|" \
		-e "s|cc(\\['xdg-desktop-menu', 'forceupdate'\\])|#\\0|" \
		-e "s|'xdg-mime', 'install'|\\0, '--mode', 'user'|" \
		-i src/calibre/linux.py || die "sed failed to patch linux.py"

	# Disable unnecessary privilege dropping for bug #287067.
	sed \
		-e "s:if os.geteuid() == 0:if False and os.geteuid() == 0:" \
		-i setup/install.py || die "sed failed to patch install.py"

	sed -e "/^            self\\.check_call(qmc + \\[.*\\.pro'\\])$/a\
\\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ self.check_call(['sed', \
'-e', 's|^CFLAGS .*|\\\\\\\\0 ${CFLAGS}|', \
'-e', 's|^CXXFLAGS .*|\\\\\\\\0 ${CXXFLAGS}|', \
'-e', 's|^LFLAGS .*|\\\\\\\\0 ${LDFLAGS}|', \
'-i', 'Makefile'])" \
		-i setup/extensions.py || die "sed failed to patch extensions.py"

	# use system beautifulsoup, instead of bundled
	rm -f "${S}"/src/calibre/ebooks/BeautifulSoup.py || die "could not remove bundled beautifulsoup"
	find "${S}" -type f -name \*.py -exec \
		sed -e 's/calibre.ebooks.BeautifulSoup/BeautifulSoup/' -i {} + \
		|| die "could not sed bundled beautifulsoup out of the source tree"

	# override install path for bash-completions
	local mybcd="${D}/$(get_bashcompdir)"
	sed -e "s#^def \(get_bash_completion_path.*\)\$#def \1\n    return os.path.join('${mybcd}','calibre')\n\ndef old_\1#" \
	  -i "${S}"/src/calibre/linux.py || die "Could not fix bash-completions install path"

	tc-export CC CXX

	distutils-r1_python_prepare_all
}

python_install() {
	# Bypass kbuildsycoca and update-mime-database in order to
	# avoid sandbox violations if xdg-mime tries to call them.
	cat - > "${T}/kbuildsycoca" <<-EOF
	#!${BASH}
	exit 0
	EOF

	cp "${T}"/{kbuildsycoca,update-mime-database} || die
	chmod +x "${T}"/{kbuildsycoca,update-mime-database} || die

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

	export_xdg_dirs
	mkdir -p "${XDG_CONFIG_HOME}" "${CALIBRE_CONFIG_DIRECTORY}" || die

	# Bug #334243 - respect LDFLAGS when building extensions
	export OVERRIDE_CFLAGS="$CFLAGS" OVERRIDE_LDFLAGS="$LDFLAGS"
	local libdir=$(get_libdir)
	[[ -n $libdir ]] || die "get_libdir returned an empty string"

	# Bug #472690 - Avoid sandbox violation for /dev/dri/card0.
	local x
	for x in /dev/dri/card[0-9] ; do
		[[ -e ${x} ]] && addpredict ${x}
	done

	dodir $(python_get_sitedir) # for init_calibre.py
	PATH=${T}:${PATH} PYTHONPATH=${S}/src${PYTHONPATH:+:}${PYTHONPATH} \
	esetup.py install \
		--root="${D}" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/${libdir}" \
		--staging-root="${ED}usr" \
		--staging-libdir="${ED}usr/${libdir}"
}

python_install_all() {
	export_xdg_dirs

	python_replicate_script "${ED}"/usr/bin/*

	grep -rlZ "${ED}" "${ED}" | xargs -0 sed -e "s:${D}:/:g" -i ||
		die "failed to fix harcoded \$D in paths"

	# The menu entries end up here due to '--mode user' being added to
	# xdg-* options in src_prepare.
	dodir /usr/share/mime/packages
	chmod -fR a+rX,u+w,g-w,o-w "${HOME}"/.local || die
	mv "${HOME}"/.local/share/mime/packages/* "${ED}"usr/share/mime/packages/ ||
		die "failed to register mime types"
	dodir /usr/share/icons
	mv "${HOME}"/.local/share/icons/* "${ED}"usr/share/icons/ ||
		die "failed to install icon files"

	domenu "${HOME}"/.local/share/applications/*.desktop

	find "${ED}"usr/share -type d -empty -delete || die

	cd "${ED}"/usr/share/calibre/fonts/liberation || die
	local x
	for x in * ; do
		[[ -f ${EROOT}usr/share/fonts/liberation-fonts/${x} ]] || continue
		ln -sf "../../../fonts/liberation-fonts/${x}" "${x}" || die
	done

	einfo "Compiling python modules"
	python_foreach_impl python_optimize "${ED}"usr/$(get_libdir)/${PN}

	newinitd "${FILESDIR}"/calibre-server.init calibre-server
	newconfd "${FILESDIR}"/calibre-server.conf calibre-server

	bashcomp_alias calibre \
		lrf2lrs \
		ebook-meta \
		ebook-polish \
		lrfviewer \
		ebook-viewer \
		ebook-edit \
		fetch-ebook-metadata \
		calibre-smtp \
		calibre-server \
		calibre-debug \
		ebook-device \
		ebook-convert

}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
