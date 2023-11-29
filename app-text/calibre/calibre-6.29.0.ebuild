# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="sqlite,ssl"

inherit edo toolchain-funcs python-single-r1 qmake-utils verify-sig xdg

DESCRIPTION="Ebook management application"
HOMEPAGE="https://calibre-ebook.com/"
SRC_URI="
	https://download.calibre-ebook.com/${PV}/${P}.tar.xz
	verify-sig? ( https://calibre-ebook.com/signatures/${P}.tar.xz.sig )
"
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/kovidgoyal.gpg

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
KEYWORDS="~amd64"
SLOT="0"
IUSE="+font-subsetting ios speech +system-mathjax test +udisks unrar"

RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Qt slotted dependencies are used because the libheadless.so plugin links to
# QT_*_PRIVATE_ABI. It only uses core/gui/dbus.
COMMON_DEPEND="${PYTHON_DEPS}
	app-i18n/uchardet
	>=app-text/hunspell-1.7:=
	>=app-text/podofo-0.10.0:=
	app-text/poppler[utils]
	dev-libs/hyphen:=
	>=dev-libs/icu-57.1:=
	dev-libs/openssl:=
	dev-libs/snowball-stemmer:=
	$(python_gen_cond_dep '
		>=dev-python/apsw-3.25.2_p1[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		>=dev-python/css-parser-1.0.4[${PYTHON_USEDEP}]
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
		>=dev-python/pillow-3.2.0[jpeg,truetype,webp,zlib,${PYTHON_USEDEP}]
		>=dev-python/psutil-4.3.0[${PYTHON_USEDEP}]
		>=dev-python/pychm-0.8.6[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.5.3[${PYTHON_USEDEP}]
		dev-python/PyQt6[gui,network,opengl,printsupport,quick,svg,widgets,${PYTHON_USEDEP}]
		dev-python/PyQt6-WebEngine[widgets,${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
		dev-python/zeroconf[${PYTHON_USEDEP}]
	')
	dev-qt/qtbase:6=[gui,widgets]
	dev-qt/qtimageformats:6
	dev-util/desktop-file-utils
	dev-util/gtk-update-icon-cache
	media-fonts/liberation-fonts
	media-libs/fontconfig:=
	>=media-libs/freetype-2:=
	>=media-libs/libmtp-1.1.11:=
	>=media-gfx/optipng-0.7.6
	virtual/libusb:1=
	x11-misc/shared-mime-info
	>=x11-misc/xdg-utils-1.0.2-r2
	font-subsetting? ( $(python_gen_cond_dep 'dev-python/fonttools[${PYTHON_USEDEP}]') )
	ios? (
		>=app-pda/usbmuxd-1.0.8
		>=app-pda/libimobiledevice-1.2.0
	)
	speech? ( $(python_gen_cond_dep 'app-accessibility/speech-dispatcher[python,${PYTHON_USEDEP}]') )
	system-mathjax? ( >=dev-libs/mathjax-3 )
	udisks? ( virtual/libudev )
	unrar? ( dev-python/unrardll )
"
RDEPEND="${COMMON_DEPEND}
	udisks? ( sys-fs/udisks:2 )"
DEPEND="${COMMON_DEPEND}
	test? ( $(python_gen_cond_dep '>=dev-python/chardet-3.0.3[${PYTHON_USEDEP}]') )
"
BDEPEND="$(python_gen_cond_dep '
		>=dev-python/PyQt-builder-1.10.3[${PYTHON_USEDEP}]
		>=dev-python/sip-5[${PYTHON_USEDEP}]
	')
	virtual/pkgconfig
	system-mathjax? ( dev-lang/rapydscript-ng )
	verify-sig? ( sec-keys/openpgp-keys-kovidgoyal )
"

PATCHES=(
	# Skip calling a binary (JxrDecApp) from libjxr which is used for tests
	# We don't (yet?) package libjxr and it seems to be dead upstream
	# (last commit in 2017)
	"${FILESDIR}/${PN}-5.35.0-jxr-test.patch"
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
	# If in doubt about a problem, checking Fedora's packaging is recommended.

	# Disable unnecessary privilege dropping for bug #287067.
	sed -e "s:if os.geteuid() == 0:if False and os.geteuid() == 0:" \
		-i setup/install.py || die "sed failed to patch install.py"

	# This is only ever used at build time. It contains a small embedded copy
	# of the rapydscript-ng compiler usable inside of qtwebengine, if you don't
	# have rapydscript-ng (a nodejs package) itself installed. Its only purpose
	# is to build some resources that come bundled in dist tarballs already...
	# and which we may also need to regenerate e.g. to use system-mathjax.
	#
	# However, running qtwebengine violates the portage sandbox (among other
	# things, it tries to create directories in /usr! amazing) so this is a
	# wash anyway. The only real solution here is to package rapydscript-ng.
	#
	# We do not need it at build time, and *no one* needs it at install time.
	# Delete the cruft.
	rm -r resources/rapydscript/ || die
}

src_compile() {
	# TODO: get qmake called by setup.py to respect CC and CXX too
	tc-export CC CXX

	# bug 821871
	local MY_LIBDIR="${ESYSROOT}/usr/$(get_libdir)"
	export FT_LIB_DIR="${MY_LIBDIR}" HUNSPELL_LIB_DIR="${MY_LIBDIR}" PODOFO_LIB_DIR="${MY_LIBDIR}"
	export QMAKE="$(qt6_get_bindir)/qmake"

	edo ${EPYTHON} setup.py build
	edo ${EPYTHON} setup.py gui

	# A few different resources are bundled in the distfile by default, because
	# not all systems necessarily have them. We un-vendor them, using the
	# upstream integrated approach if possible. See setup/revendor.py and
	# consider migrating other resources to this if they do not use it, in
	# *preference* over manual rm'ing.
	edo ${EPYTHON} setup.py liberation_fonts \
		--path-to-liberation_fonts "${EPREFIX}"/usr/share/fonts/liberation-fonts \
		--system-liberation_fonts
	if use system-mathjax; then
		edo ${EPYTHON} setup.py mathjax --path-to-mathjax "${EPREFIX}"/usr/share/mathjax --system-mathjax
		edo ${EPYTHON} setup.py rapydscript
	fi
}

src_test() {
	# Skipped tests:
	local _test_excludes=(
		# unpackaged Python dependency: py7zr
		7z
		# unpackaged Python dependency: pyzstd
		test_zstd
		# tests if a completely unused module is bundled
		pycryptodome

		$(usev !speech speech_dispatcher)
		$(usev !unrar test_unrar)

		# undocumented reasons
		test_mem_leaks
		test_searching
	)

	edo ${PYTHON} setup.py test "${_test_excludes[@]/#/--exclude-test-name=}"
}

src_install() {
	# Bug #352625 - Some LANGUAGE values can trigger the following ValueError:
	#   File "/usr/lib/python2.6/locale.py", line 486, in getdefaultlocale
	#    return _parse_localename(localename)
	#  File "/usr/lib/python2.6/locale.py", line 418, in _parse_localename
	#    raise ValueError, 'unknown locale: %s' % localename
	#ValueError: unknown locale: 46
	export -n LANG LANGUAGE ${!LC_*}
	export LC_ALL=C.utf8 # bug #709682

	# Bug #295672 - Avoid sandbox violation in ~/.config by forcing
	# variables to point to our fake temporary $HOME.
	export HOME="${T}/fake_homedir"
	export CALIBRE_CONFIG_DIRECTORY="${HOME}/.config/calibre"
	mkdir -p "${CALIBRE_CONFIG_DIRECTORY}" || die

	addpredict /dev/dri #665310

	# If this directory doesn't exist, zsh completion won't install
	dodir /usr/share/zsh/site-functions

	edo "${PYTHON}" setup.py install \
		--staging-root="${ED}/usr" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--staging-libdir="${ED}/usr/$(get_libdir)" \
		--system-plugins-location="${EPREFIX}/usr/share/calibre/system-plugins"

	cp -r man-pages/ "${ED}"/usr/share/man || die

	find "${ED}"/usr/share -type d -empty -delete || die

	python_fix_shebang "${ED}/usr/bin"

	python_optimize "${ED}"/usr/$(get_libdir)/calibre "${D}/$(python_get_sitedir)"

	newinitd "${FILESDIR}"/calibre-server-3.init calibre-server
	newconfd "${FILESDIR}"/calibre-server-3.conf calibre-server
}
