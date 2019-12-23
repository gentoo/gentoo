# Copyright 2010-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=(python2_7)

inherit elisp-common multiprocessing python-any-r1 toolchain-funcs

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/google/mozc"
	EGIT_SUBMODULES=(src/third_party/japanese_usage_dictionary)
else
	MOZC_GIT_REVISION=""
	JAPANESE_USAGE_DICTIONARY_GIT_REVISION=""
	JAPANESE_USAGE_DICTIONARY_DATE=""
	FCITX_PATCH_VERSION=""
fi

DESCRIPTION="Mozc - Japanese input method editor"
HOMEPAGE="https://github.com/google/mozc"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/google/${PN}/archive/${MOZC_GIT_REVISION}.tar.gz -> ${P}.tar.gz
		https://github.com/hiroyuki-komatsu/japanese-usage-dictionary/archive/${JAPANESE_USAGE_DICTIONARY_GIT_REVISION}.tar.gz -> japanese-usage-dictionary-${JAPANESE_USAGE_DICTIONARY_DATE}.tar.gz
		fcitx4? ( https://download.fcitx-im.org/fcitx-mozc/fcitx-mozc-${FCITX_PATCH_VERSION}.patch )"
fi

# Mozc: BSD
# src/data/dictionary_oss: ipadic, public-domain
# src/data/unicode: unicode
# japanese-usage-dictionary: BSD-2
LICENSE="BSD BSD-2 ipadic public-domain unicode"
SLOT="0"
KEYWORDS=""
IUSE="debug emacs fcitx4 +gui +handwriting-tegaki handwriting-tomoe ibus renderer test"
REQUIRED_USE="|| ( emacs fcitx4 ibus ) gui? ( ^^ ( handwriting-tegaki handwriting-tomoe ) ) !gui? ( !handwriting-tegaki !handwriting-tomoe )"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	>=dev-libs/protobuf-3.0.0
	dev-util/gyp
	dev-util/ninja
	virtual/pkgconfig
	emacs? ( app-editors/emacs:* )
	fcitx4? ( sys-devel/gettext )"
RDEPEND=">=dev-libs/protobuf-3.0.0:=
	emacs? ( app-editors/emacs:* )
	fcitx4? (
		app-i18n/fcitx:4
		virtual/libintl
	)
	gui? (
		app-i18n/zinnia
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		handwriting-tegaki? ( app-i18n/tegaki-zinnia-japanese )
		handwriting-tomoe? ( app-i18n/zinnia-tomoe )
	)
	ibus? (
		>=app-i18n/ibus-1.4.1
		dev-libs/glib:2
		x11-libs/libxcb
	)
	renderer? (
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/gtk+:2
		x11-libs/pango
	)"
DEPEND="${RDEPEND}
	test? (
		>=dev-cpp/gtest-1.8.0
		dev-libs/jsoncpp
	)"

S="${WORKDIR}/${P}/src"

SITEFILE="50${PN}-gentoo.el"

execute() {
	einfo "$@"
	"$@"
}

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack

		if use fcitx4; then
			local EGIT_SUBMODULES=()
			git-r3_fetch https://gitlab.com/fcitx/mozc.git refs/heads/fcitx
			git-r3_checkout https://gitlab.com/fcitx/mozc.git "${WORKDIR}/fcitx-mozc"
		fi
	else
		unpack ${P}.tar.gz
		mv mozc-${MOZC_GIT_REVISION} ${P} || die

		unpack japanese-usage-dictionary-${JAPANESE_USAGE_DICTIONARY_DATE}.tar.gz
		cp -p japanese-usage-dictionary-${JAPANESE_USAGE_DICTIONARY_GIT_REVISION}/usage_dict.txt ${P}/src/third_party/japanese_usage_dictionary || die
	fi
}

src_prepare() {
	eapply -p2 "${FILESDIR}/${PN}-2.23.2815.102-system_libraries.patch"
	eapply -p2 "${FILESDIR}/${PN}-2.23.2815.102-gcc-8.patch"
	eapply -p2 "${FILESDIR}/${PN}-2.23.2815.102-protobuf_generated_classes_no_inheritance.patch"
	eapply -p2 "${FILESDIR}/${PN}-2.23.2815.102-environmental_variables.patch"
	eapply -p2 "${FILESDIR}/${PN}-2.23.2815.102-reiwa.patch"
	eapply -p2 "${FILESDIR}/${PN}-2.20.2673.102-tests_build.patch"
	eapply -p2 "${FILESDIR}/${PN}-2.20.2673.102-tests_skipping.patch"

	if use fcitx4; then
		if [[ "${PV}" == "9999" ]]; then
			cp -pr "${WORKDIR}/fcitx-mozc/src/unix/fcitx" unix || die
		else
			eapply -p2 "${DISTDIR}/fcitx-mozc-${FCITX_PATCH_VERSION}.patch"
		fi
	fi

	eapply_user

	sed \
		-e "s/def GypMain(options, unused_args):/def GypMain(options, gyp_args):/" \
		-e "s/RunOrDie(gyp_command + gyp_options)/RunOrDie(gyp_command + gyp_options + gyp_args)/" \
		-e "s/RunOrDie(\[ninja/&, '-j$(makeopts_jobs)', '-l$(makeopts_loadavg "${MAKEOPTS}" 0)', '-v'/" \
		-i build_mozc.py || die

	sed \
		-e "s/'release_extra_cflags%': \['-O2'\]/'release_extra_cflags%': []/" \
		-e "s/'debug_extra_cflags%': \['-O0', '-g'\]/'debug_extra_cflags%': []/" \
		-i gyp/common.gypi || die

	local ar=($(tc-getAR))
	local cc=($(tc-getCC))
	local cxx=($(tc-getCXX))
	local ld=($(tc-getLD))
	local nm=($(tc-getNM))
	local readelf=($(tc-getPROG READELF readelf))

	# Use absolute paths. Non-absolute paths are mishandled by GYP.
	ar[0]=$(type -P ${ar[0]})
	cc[0]=$(type -P ${cc[0]})
	cxx[0]=$(type -P ${cxx[0]})
	ld[0]=$(type -P ${ld[0]})
	nm[0]=$(type -P ${nm[0]})
	readelf[0]=$(type -P ${readelf[0]})

	sed \
		-e "s:<!(which ar):${ar[@]}:" \
		-e "s:<!(which clang):${cc[@]}:" \
		-e "s:<!(which clang++):${cxx[@]}:" \
		-e "s:<!(which ld):${ld[@]}:" \
		-e "s:<!(which nm):${nm[@]}:" \
		-e "s:<!(which readelf):${readelf[@]}:" \
		-i gyp/common.gypi || die
}

src_configure() {
	if use debug; then
		BUILD_TYPE="Debug"
	else
		BUILD_TYPE="Release"
	fi

	local gyp_arguments=()

	if tc-is-gcc; then
		gyp_arguments+=(-D compiler_host=gcc -D compiler_target=gcc)
	elif tc-is-clang; then
		gyp_arguments+=(-D compiler_host=clang -D compiler_target=clang)
	else
		gyp_arguments+=(-D compiler_host=unknown -D compiler_target=unknown)
	fi

	gyp_arguments+=(-D use_fcitx=$(usex fcitx4 YES NO))
	gyp_arguments+=(-D use_libgtest=$(usex test 1 0))
	gyp_arguments+=(-D use_libibus=$(usex ibus 1 0))
	gyp_arguments+=(-D use_libjsoncpp=$(usex test 1 0))
	gyp_arguments+=(-D use_libprotobuf=1)
	gyp_arguments+=(-D use_libzinnia=$(usex gui 1 0))
	gyp_arguments+=(-D enable_gtk_renderer=$(usex renderer 1 0))

	gyp_arguments+=(-D server_dir="${EPREFIX}/usr/libexec/mozc")
	gyp_arguments+=(-D document_dir="${EPREFIX}/usr/libexec/mozc/documents")

	if use handwriting-tegaki; then
		gyp_arguments+=(-D zinnia_model_file="${EPREFIX}/usr/share/tegaki/models/zinnia/handwriting-ja.model")
	elif use handwriting-tomoe; then
		gyp_arguments+=(-D zinnia_model_file="${EPREFIX}/usr/$(get_libdir)/zinnia/model/tomoe/handwriting-ja.model")
	fi

	if use ibus; then
		gyp_arguments+=(-D ibus_mozc_path="${EPREFIX}/usr/libexec/ibus-engine-mozc")
		gyp_arguments+=(-D ibus_mozc_icon_path="${EPREFIX}/usr/share/ibus-mozc/product_icon.png")
	fi

	unset AR CC CXX LD NM READELF

	execute "${PYTHON}" build_mozc.py gyp \
		--gypdir="${EPREFIX}/usr/bin" \
		--server_dir="${EPREFIX}/usr/libexec/mozc" \
		--verbose \
		$(usex gui "" --noqt) \
		-- "${gyp_arguments[@]}" || die "Configuration failed"
}

src_compile() {
	local targets=(server/server.gyp:mozc_server)
	if use emacs; then
		targets+=(unix/emacs/emacs.gyp:mozc_emacs_helper)
	fi
	if use fcitx4; then
		targets+=(unix/fcitx/fcitx.gyp:fcitx-mozc)
	fi
	if use gui; then
		targets+=(gui/gui.gyp:mozc_tool)
	fi
	if use ibus; then
		targets+=(unix/ibus/ibus.gyp:ibus_mozc)
	fi
	if use renderer; then
		targets+=(renderer/renderer.gyp:mozc_renderer)
	fi
	if use test; then
		targets+=(gyp/tests.gyp:unittests)
	fi

	execute "${PYTHON}" build_mozc.py build -c ${BUILD_TYPE} -v "${targets[@]}" || die "Building failed"

	if use emacs; then
		elisp-compile unix/emacs/*.el
	fi
}

src_test() {
	execute "${PYTHON}" build_mozc.py runtests -c ${BUILD_TYPE} --test_jobs 1 || die "Testing failed"
}

src_install() {
	exeinto /usr/libexec/mozc
	doexe out_linux/${BUILD_TYPE}/mozc_server

	if use gui; then
		doexe out_linux/${BUILD_TYPE}/mozc_tool
	fi

	if use renderer; then
		doexe out_linux/${BUILD_TYPE}/mozc_renderer
	fi

	insinto /usr/libexec/mozc/documents
	doins data/installer/credits_en.html

	if use emacs; then
		dobin out_linux/${BUILD_TYPE}/mozc_emacs_helper
		elisp-install ${PN} unix/emacs/*.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" ${PN}
	fi

	if use fcitx4; then
		exeinto /usr/$(get_libdir)/fcitx
		doexe out_linux/${BUILD_TYPE}/fcitx-mozc.so

		insinto /usr/share/fcitx/addon
		doins unix/fcitx/fcitx-mozc.conf

		insinto /usr/share/fcitx/inputmethod
		doins unix/fcitx/mozc.conf

		insinto /usr/share/fcitx/mozc/icon
		newins data/images/product_icon_32bpp-128.png mozc.png
		local image
		for image in data/images/unix/ui-*.png; do
			newins "${image}" "mozc-${image#data/images/unix/ui-}"
		done

		local locale mo_file
		for mo_file in out_linux/${BUILD_TYPE}/gen/unix/fcitx/po/*.mo; do
			locale="${mo_file##*/}"
			locale="${locale%.mo}"
			insinto /usr/share/locale/${locale}/LC_MESSAGES
			newins "${mo_file}" fcitx-mozc.mo
		done
	fi

	if use ibus; then
		exeinto /usr/libexec
		newexe out_linux/${BUILD_TYPE}/ibus_mozc ibus-engine-mozc

		insinto /usr/share/ibus/component
		doins out_linux/${BUILD_TYPE}/gen/unix/ibus/mozc.xml

		insinto /usr/share/ibus-mozc
		newins data/images/unix/ime_product_icon_opensource-32.png product_icon.png
		local image
		for image in data/images/unix/ui-*.png; do
			newins "${image}" "${image#data/images/unix/ui-}"
		done
	fi
}

pkg_postinst() {
	elog
	elog "ENVIRONMENTAL VARIABLES"
	elog
	elog "MOZC_SERVER_DIRECTORY"
	elog "  Mozc server directory"
	elog "  Value used by default: \"${EPREFIX}/usr/libexec/mozc\""
	elog "MOZC_DOCUMENTS_DIRECTORY"
	elog "  Mozc documents directory"
	elog "  Value used by default: \"${EPREFIX}/usr/libexec/mozc/documents\""
	elog "MOZC_CONFIGURATION_DIRECTORY"
	elog "  Mozc configuration directory"
	elog "  Value used by default: \"~/.mozc\""
	if use gui; then
		elog "MOZC_ZINNIA_MODEL_FILE"
		elog "  Zinnia handwriting recognition model file"
		if use handwriting-tegaki; then
			elog "  Value used by default: \"${EPREFIX}/usr/share/tegaki/models/zinnia/handwriting-ja.model\""
		elif use handwriting-tomoe; then
			elog "  Value used by default: \"${EPREFIX}/usr/$(get_libdir)/zinnia/model/tomoe/handwriting-ja.model\""
		fi
		elog "  Potential values:"
		elog "    \"${EPREFIX}/usr/share/tegaki/models/zinnia/handwriting-ja.model\""
		elog "    \"${EPREFIX}/usr/$(get_libdir)/zinnia/model/tomoe/handwriting-ja.model\""
	fi
	elog
	if use emacs; then
		elog
		elog "USAGE IN EMACS"
		elog
		elog "mozc-mode is minor mode to input Japanese text using Mozc server."
		elog "mozc-mode can be used via LEIM (Library of Emacs Input Method)."
		elog
		elog "In order to use mozc-mode by default, the following settings should be added to"
		elog "Emacs init file (~/.emacs.d/init.el or ~/.emacs):"
		elog
		elog "  (require 'mozc)"
		elog "  (set-language-environment \"Japanese\")"
		elog "  (setq default-input-method \"japanese-mozc\")"
		elog
		elog "With the above settings, typing C-\\ (which is bound to \"toggle-input-method\""
		elog "by default) will enable mozc-mode."
		elog
		elog "Alternatively, at run time, after loading mozc.el, mozc-mode can be activated by"
		elog "calling \"set-input-method\" and entering \"japanese-mozc\"."
		elog

		elisp-site-regen
	fi
}

pkg_postrm() {
	if use emacs; then
		elisp-site-regen
	fi
}
