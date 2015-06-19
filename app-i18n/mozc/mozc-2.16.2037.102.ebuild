# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/mozc/mozc-2.16.2037.102.ebuild,v 1.6 2015/04/08 07:30:31 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PLOCALES="de ja zh_CN zh_TW"
inherit elisp-common eutils l10n multilib multiprocessing python-single-r1 toolchain-funcs

DESCRIPTION="The Mozc engine for IBus Framework"
HOMEPAGE="http://code.google.com/p/mozc/"

PROTOBUF_VER="2.5.0"
GMOCK_VER="1.6.0"
GTEST_VER="1.6.0"
JSONCPP_VER="0.6.0-rc2"
GYP_DATE="20140602"
JAPANESE_USAGE_DICT_VER="10"
FCITX_PATCH_VER="2"
FCITX_PATCH="fcitx-mozc-${PV}.${FCITX_PATCH_VER}.patch"
MOZC_URL="http://dev.gentoo.org/~naota/files/${P}.tar.bz2"
PROTOBUF_URL="http://protobuf.googlecode.com/files/protobuf-${PROTOBUF_VER}.tar.bz2"
GMOCK_URL="https://googlemock.googlecode.com/files/gmock-${GMOCK_VER}.zip"
GTEST_URL="https://googletest.googlecode.com/files/gtest-${GTEST_VER}.zip"
JSONCPP_URL="mirror://sourceforge/jsoncpp/jsoncpp-src-${JSONCPP_VER}.tar.gz"
GYP_URL="http://dev.gentoo.org/~naota/files/gyp-${GYP_DATE}.tar.bz2"
JAPANESE_USAGE_DICT_URL="http://dev.gentoo.org/~naota/files/japanese-usage-dictionary-${JAPANESE_USAGE_DICT_VER}.tar.bz2"
FCITX_PATCH_URL="http://download.fcitx-im.org/fcitx-mozc/${FCITX_PATCH}"
SRC_URI="${MOZC_URL} ${PROTOBUF_URL} ${GYP_URL} ${JAPANESE_USAGE_DICT_URL}
	fcitx? ( ${FCITX_PATCH_URL} )
	test? ( ${GMOCK_URL} ${GTEST_URL} ${JSONCPP_URL} )"

LICENSE="BSD ipadic public-domain unicode"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs fcitx +ibus +qt4 renderer test"

RDEPEND="app-i18n/tegaki-zinnia-japanese
	dev-libs/glib:2
	>=dev-libs/protobuf-2.5.0
	x11-libs/libxcb
	emacs? ( virtual/emacs )
	fcitx? ( app-i18n/fcitx )
	ibus? (
		>=app-i18n/ibus-1.4.1
		qt4? ( app-i18n/ibus-qt )
	)
	renderer? ( x11-libs/gtk+:2 )
	qt4? (
		dev-qt/qtgui:4
		app-i18n/zinnia
	)
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-util/ninja
	virtual/pkgconfig"

BUILDTYPE="${BUILDTYPE:-Release}"

RESTRICT="test"

SITEFILE=50${PN}-gentoo.el

src_unpack() {
	unpack $(basename ${MOZC_URL})

	unpack $(basename ${GYP_URL})
	unpack $(basename ${JAPANESE_USAGE_DICT_URL})
	mv gyp-${GYP_DATE} "${S}"/third_party/gyp || die
	mv japanese-usage-dictionary-${JAPANESE_USAGE_DICT_VER} "${S}"/third_party/japanese_usage_dictionary || die

	cd "${S}"/protobuf
	unpack $(basename ${PROTOBUF_URL})
	mv protobuf-${PROTOBUF_VER} files || die

	if use test; then
		cd "${S}"/third_party
		unpack $(basename ${GMOCK_URL}) $(basename ${GTEST_URL}) \
			$(basename ${JSONCPP_URL})
		mv gmock-${GMOCK_VER} gmock || die
		mv gtest-${GTEST_VER} gtest || die
		mv jsoncpp-src-${JSONCPP_VER} jsoncpp || die
	fi
}

src_prepare() {
	# verbose build
	sed -i -e "/RunOrDie(\[make_command\]/s/build_args/build_args + [\"-v\"]/" \
		build_mozc.py || die
	sed -i -e "s/<!(which clang)/$(tc-getCC)/" \
		-e "s/<!(which clang++)/$(tc-getCXX)/" \
		gyp/common.gypi || die
	if use fcitx; then
		EPATCH_OPTS="-p2" epatch "${DISTDIR}/${FCITX_PATCH}"
	fi
	epatch_user
}

src_configure() {
	local myconf="--server_dir=/usr/$(get_libdir)/mozc"

	if ! use qt4 ; then
		myconf+=" --noqt"
		export GYP_DEFINES="use_libzinnia=0"
	fi

	if ! use renderer ; then
		export GYP_DEFINES="${GYP_DEFINES} enable_gtk_renderer=0"
	fi

	export GYP_DEFINES="${GYP_DEFINES} use_libprotobuf=1 compiler_target=gcc compiler_host=gcc"

	tc-export CC CXX AR AS RANLIB LD NM

	"${PYTHON}" build_mozc.py gyp -v ${myconf} || die "gyp failed"
}

src_compile() {
	tc-export CC CXX AR AS RANLIB LD

	local my_makeopts=$(makeopts_jobs)
	# This is for a safety. -j without a number, makeopts_jobs returns 999.
	local myjobs=-j${my_makeopts/999/1}

	local mytarget="server/server.gyp:mozc_server"
	use emacs && mytarget="${mytarget} unix/emacs/emacs.gyp:mozc_emacs_helper"
	use fcitx && mytarget="${mytarget} unix/fcitx/fcitx.gyp:fcitx-mozc"
	use ibus && mytarget="${mytarget} unix/ibus/ibus.gyp:ibus_mozc"
	use renderer && mytarget="${mytarget} renderer/renderer.gyp:mozc_renderer"
	if use qt4 ; then
		export QTDIR="${EPREFIX}/usr"
		mytarget="${mytarget} gui/gui.gyp:mozc_tool"
	fi

	# V=1 "${PYTHON}" build_mozc.py build_tools -c "${BUILDTYPE}" ${myjobs} || die
	"${PYTHON}" build_mozc.py build -v -c "${BUILDTYPE}" ${mytarget} ${myjobs} || die

	if use emacs ; then
		elisp-compile unix/emacs/*.el || die
	fi
}

src_test() {
	tc-export CC CXX AR AS RANLIB LD
	V=1 "${PYTHON}" build_mozc.py runtests -c "${BUILDTYPE}" || die
}
src_install() {
	install_fcitx_locale() {
		lang=$1
		insinto "/usr/share/locale/${lang}/LC_MESSAGES/"
		newins out_linux/${BUILDTYPE}/gen/unix/fcitx/po/${lang}.mo fcitx-mozc.mo
	}

	if use emacs ; then
		dobin "out_linux/${BUILDTYPE}/mozc_emacs_helper" || die
		elisp-install ${PN} unix/emacs/*.{el,elc} || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" ${PN} || die
	fi

	if use fcitx; then
		exeinto /usr/$(get_libdir)/fcitx
		doexe "out_linux/${BUILDTYPE}/fcitx-mozc.so"
		insinto /usr/share/fcitx/addon
		doins "unix/fcitx/fcitx-mozc.conf"
		insinto /usr/share/fcitx/inputmethod
		doins "unix/fcitx/mozc.conf"
		insinto /usr/share/fcitx/mozc/icon
		(
			cd data/images
			newins product_icon_32bpp-128.png mozc.png
			cd unix
			for f in ui-* ; do
				newins ${f} mozc-${f/ui-}
			done
		)
		l10n_for_each_locale_do install_fcitx_locale
	fi

	if use ibus ; then
		exeinto /usr/$(get_libdir)/ibus-mozc || die
		newexe "out_linux/${BUILDTYPE}/ibus_mozc" ibus-engine-mozc || die
		insinto /usr/share/ibus/component || die
		doins "out_linux/${BUILDTYPE}/gen/unix/ibus/mozc.xml" || die
		insinto /usr/share/ibus-mozc || die
		(
			cd data/images/unix
			newins ime_product_icon_opensource-32.png product_icon.png || die
			for f in ui-*
			do
				newins ${f} ${f/ui-} || die
			done
		)

	fi

	exeinto "/usr/$(get_libdir)/mozc" || die
	doexe "out_linux/${BUILDTYPE}/mozc_server" || die

	if use qt4 ; then
		exeinto "/usr/$(get_libdir)/mozc" || die
		doexe "out_linux/${BUILDTYPE}/mozc_tool" || die
	fi

	if use renderer ; then
		exeinto "/usr/$(get_libdir)/mozc" || die
		doexe "out_linux/${BUILDTYPE}/mozc_renderer" || die
	fi
}

pkg_postinst() {
	if use emacs ; then
		elisp-site-regen
		elog "You can use mozc-mode via LEIM (Library of Emacs Input Method)."
		elog "Write the following settings into your init file (~/.emacs.d/init.el"
		elog "or ~/.emacs) in order to use mozc-mode by default, or you can call"
		elog "\`set-input-method' and set \"japanese-mozc\" anytime you have loaded"
		elog "mozc.el"
		elog
		elog "  (require 'mozc)"
		elog "  (set-language-environment \"Japanese\")"
		elog "  (setq default-input-method \"japanese-mozc\")"
		elog
		elog "Having the above settings, just type C-\\ which is bound to"
		elog "\`toggle-input-method' by default."
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
