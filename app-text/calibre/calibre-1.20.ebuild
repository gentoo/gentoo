# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fdo-mime bash-completion-r1 multilib toolchain-funcs qmake-utils

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

KEYWORDS="amd64 x86"
SLOT="0"
IUSE="+udisks"

COMMON_DEPEND="
	>=app-text/podofo-0.8.2:=
	>=app-text/poppler-0.12.3-r3:=[qt4,xpdf-headers(+)]
	>=dev-lang/python-2.7.1:2.7[sqlite,ssl]
	>=dev-libs/chmlib-0.40:=
	>=dev-libs/icu-4.4:=
	dev-python/apsw
	>=dev-python/beautifulsoup-3.0.5:python-2
	dev-python/netifaces
	>=dev-python/dnspython-1.6.0:py2
	>=dev-python/cssselect-0.7.1
	>=dev-python/cssutils-0.9.9
	>=dev-python/dbus-python-0.82.2
	dev-python/pillow
	>=dev-python/lxml-2.2.1
	>=dev-python/mechanize-0.1.11
	>=dev-python/python-dateutil-1.4.1[python_targets_python2_7(-)]
	|| ( >=dev-python/PyQt4-4.11.2-r1[X,compat(-),svg,webkit] <dev-python/PyQt4-4.11.2-r1[X,svg,webkit] )
	media-fonts/liberation-fonts
	>=media-gfx/imagemagick-6.5.9[jpeg,png]
	>=media-libs/freetype-2:=
	>=media-libs/libwmf-0.2.8
	>=media-libs/libmtp-1.1.4:=
	virtual/libusb:1=
	dev-qt/qtdbus:4=
	dev-qt/qtsvg:4=
	>=x11-misc/xdg-utils-1.0.2-r2"

RDEPEND="${COMMON_DEPEND}
	udisks? ( || ( sys-fs/udisks:2 sys-fs/udisks:0 ) )"

DEPEND="${COMMON_DEPEND}
	>=dev-python/setuptools-0.6_rc5
	>=virtual/podofo-build-0.8.2"

S=${WORKDIR}/${PN}

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
		-e "s|PreserveMIMEDefaults():||" \
		-e "s|xdg-icon-resource install|\\0 --mode user|" \
		-e "s|cc(\\['xdg-desktop-menu', 'forceupdate'\\])|#\\0|" \
		-e "s|xdg-mime install|\\0 --mode user|" \
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

	# no_updates: do not annoy user with "new version is availible all the time
	# disable_plugins: walking sec-hole, wait for upstream to use GHNS interface
	epatch \
		"${FILESDIR}/${PN}-1.20-no_updates_dialog.patch" \
		"${FILESDIR}/${PN}-disable_plugins.patch"
}

src_install() {
	# Bypass kbuildsycoca and update-mime-database in order to
	# avoid sandbox violations if xdg-mime tries to call them.
	cat - > "${T}/kbuildsycoca" <<-EOF
	#!${BASH}
	exit 0
	EOF

	cp "${T}"/{kbuildsycoca,update-mime-database}
	chmod +x "${T}"/{kbuildsycoca,update-mime-database}

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
	mkdir -p "${XDG_CONFIG_HOME}" "${CALIBRE_CONFIG_DIRECTORY}"

	tc-export CC CXX
	# Bug #334243 - respect LDFLAGS when building extensions
	export OVERRIDE_CFLAGS="$CFLAGS" OVERRIDE_LDFLAGS="$LDFLAGS"
	local libdir=$(get_libdir)
	[[ -n $libdir ]] || die "get_libdir returned an empty string"

	export QMAKE="$(qt4_get_bindir)/qmake"

	# Bug #472690 - Avoid sandbox violation for /dev/dri/card0.
	local x
	for x in /dev/dri/card[0-9] ; do
		[[ -e ${x} ]] && addpredict ${x}
	done

	dodir "/usr/$(get_libdir)/python2.7/site-packages" # for init_calibre.py
	PATH=${T}:${PATH} PYTHONPATH=${S}/src${PYTHONPATH:+:}${PYTHONPATH} \
	"${EPREFIX}"/usr/bin/python2.7 setup.py install \
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

	dobashcomp "${ED}"usr/etc/bash_completion.d/calibre
	rm -r "${ED}"usr/etc/bash_completion.d
	find "${ED}"usr/etc -type d -empty -delete

	cd "${ED}"/usr/share/calibre/fonts/liberation || die
	local x
	for x in * ; do
		[[ -f ${EROOT}usr/share/fonts/liberation-fonts/${x} ]] || continue
		ln -sf "../../../fonts/liberation-fonts/${x}" "${x}" || die
	done

	einfo "Converting python shebangs"
	while read -r -d $'\0' ; do
		local shebang=$(head -n1 "$REPLY")
		if [[ ${shebang} == "#!"*python* ]] ; then
			sed -i -e "1s:.*:#!${EPREFIX}/usr/bin/python2.7:" "$REPLY" || \
				die "sed failed"
		fi
	done < <(find "${ED}" -type f -print0)

	einfo "Compiling python modules"
	"${EPREFIX}"/usr/bin/python2.7 -m compileall -q -f \
		-d "${EPREFIX}"/usr/lib/calibre "${ED}"usr/lib/calibre || die

	newinitd "${FILESDIR}"/calibre-server.init calibre-server
	newconfd "${FILESDIR}"/calibre-server.conf calibre-server
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
