# Copyright 2010-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=(python{3_7,3_8,3_9})

inherit elisp-common multiprocessing python-any-r1 toolchain-funcs

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/google/mozc"
	EGIT_SUBMODULES=(src/third_party/japanese_usage_dictionary)
else
	MOZC_GIT_REVISION="9ba59b64d53365c1fe93c1c245b4ec3e35bdadf0"
	MOZC_DATE="${PV#*_p}"
	MOZC_DATE="${MOZC_DATE%%_p*}"

	FCITX_MOZC_GIT_REVISION="1ea089debc31ff216473369ad71c08318384ee06"
	FCITX_MOZC_DATE="${PV#*_p}"
	FCITX_MOZC_DATE="${FCITX_MOZC_DATE#*_p}"
	FCITX_MOZC_DATE="${FCITX_MOZC_DATE%%_p*}"

	JAPANESE_USAGE_DICTIONARY_GIT_REVISION="a4a66772e33746b91e99caceecced9a28507e925"
	JAPANESE_USAGE_DICTIONARY_DATE="20180701040110"
fi

DESCRIPTION="Mozc - Japanese input method editor"
HOMEPAGE="https://github.com/google/mozc"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/google/${PN}/archive/${MOZC_GIT_REVISION}.tar.gz -> ${PN}-${PV%%_p*}-${MOZC_DATE}.tar.gz
		https://github.com/hiroyuki-komatsu/japanese-usage-dictionary/archive/${JAPANESE_USAGE_DICTIONARY_GIT_REVISION}.tar.gz -> japanese-usage-dictionary-${JAPANESE_USAGE_DICTIONARY_DATE}.tar.gz
		fcitx4? ( https://github.com/fcitx/${PN}/archive/${FCITX_MOZC_GIT_REVISION}.tar.gz -> fcitx-${PN}-${PV%%_p*}-${FCITX_MOZC_DATE}.tar.gz )"
fi

# Mozc: BSD
# src/data/dictionary_oss: ipadic, public-domain
# src/data/unicode: unicode
# japanese-usage-dictionary: BSD-2
LICENSE="BSD BSD-2 ipadic public-domain unicode"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 x86"
IUSE="debug emacs fcitx4 +gui ibus renderer test"
REQUIRED_USE="|| ( emacs fcitx4 ibus )"
RESTRICT="!test? ( test )"

BDEPEND="$(python_gen_any_dep 'dev-python/six[${PYTHON_USEDEP}]')
	>=dev-libs/protobuf-3.0.0
	dev-util/gyp
	dev-util/ninja
	virtual/pkgconfig
	emacs? ( app-editors/emacs:* )
	fcitx4? ( sys-devel/gettext )"
DEPEND="=dev-cpp/abseil-cpp-20200923*[cxx17(+)]
	>=dev-libs/protobuf-3.0.0:=
	fcitx4? (
		app-i18n/fcitx:4
		virtual/libintl
	)
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
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
	)
	test? (
		>=dev-cpp/gtest-1.8.0
		dev-libs/jsoncpp
	)"
RDEPEND="=dev-cpp/abseil-cpp-20200923*[cxx17(+)]
	>=dev-libs/protobuf-3.0.0:=
	emacs? ( app-editors/emacs:* )
	fcitx4? (
		app-i18n/fcitx:4
		virtual/libintl
	)
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
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

S="${WORKDIR}/${P}/src"

SITEFILE="50${PN}-gentoo.el"

execute() {
	einfo "$@"
	"$@"
}

python_check_deps() {
	has_version -b "dev-python/six[${PYTHON_USEDEP}]"
}

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack

		if use fcitx4; then
			local EGIT_SUBMODULES=()
			git-r3_fetch https://github.com/fcitx/mozc refs/heads/fcitx
			git-r3_checkout https://github.com/fcitx/mozc "${WORKDIR}/fcitx-mozc"
		fi
	else
		unpack ${PN}-${PV%%_p*}-${MOZC_DATE}.tar.gz
		mv mozc-${MOZC_GIT_REVISION} ${P} || die

		unpack japanese-usage-dictionary-${JAPANESE_USAGE_DICTIONARY_DATE}.tar.gz
		cp -p japanese-usage-dictionary-${JAPANESE_USAGE_DICTIONARY_GIT_REVISION}/usage_dict.txt ${P}/src/third_party/japanese_usage_dictionary || die

		if use fcitx4; then
			unpack fcitx-${PN}-${PV%%_p*}-${FCITX_MOZC_DATE}.tar.gz
			mv mozc-${FCITX_MOZC_GIT_REVISION} fcitx-${PN}
		fi
	fi
}

src_prepare() {
	if use fcitx4; then
		cp -pr "${WORKDIR}/fcitx-mozc/src/unix/fcitx" unix || die
	fi

	pushd "${WORKDIR}/${P}" > /dev/null || die

	eapply "${FILESDIR}/${PN}-2.26.4220-system_abseil-cpp.patch"
	eapply "${FILESDIR}/${PN}-2.26.4220-system_gtest.patch"
	eapply "${FILESDIR}/${PN}-2.26.4220-system_jsoncpp.patch"
	eapply "${FILESDIR}/${PN}-2.26.4220-environmental_variables.patch"
	eapply "${FILESDIR}/${PN}-2.26.4220-server_path_check.patch"

	eapply_user

	popd > /dev/null || die

	sed \
		-e "s/def GypMain(options, unused_args):/def GypMain(options, gyp_args):/" \
		-e "s/RunOrDie(gyp_command + gyp_options)/RunOrDie(gyp_command + gyp_options + gyp_args)/" \
		-e "s/RunOrDie(\[ninja/&, '-j$(makeopts_jobs)', '-l$(makeopts_loadavg "${MAKEOPTS}" 0)', '-v'/" \
		-i build_mozc.py || die

	local ar=($(tc-getAR))
	local cc=($(tc-getCC))
	local cxx=($(tc-getCXX))
	local ld=($(tc-getLD))
	local nm=($(tc-getNM))
	local readelf=($(tc-getREADELF))

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

	# https://github.com/google/mozc/issues/489
	sed \
		-e "/'-lc++'/d" \
		-e "/'-stdlib=libc++'/d" \
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

	gyp_arguments+=(-D debug_extra_cflags=)
	gyp_arguments+=(-D release_extra_cflags=)

	gyp_arguments+=(-D use_fcitx=$(usex fcitx4 YES NO))
	gyp_arguments+=(-D use_libibus=$(usex ibus 1 0))
	gyp_arguments+=(-D use_libprotobuf=1)
	gyp_arguments+=(-D use_system_abseil_cpp=1)
	gyp_arguments+=(-D use_system_gtest=$(usex test 1 0))
	gyp_arguments+=(-D use_system_jsoncpp=$(usex test 1 0))
	gyp_arguments+=(-D enable_gtk_renderer=$(usex renderer 1 0))

	gyp_arguments+=(-D server_dir="${EPREFIX}/usr/libexec/mozc")
	gyp_arguments+=(-D document_dir="${EPREFIX}/usr/libexec/mozc/documents")

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
		for image in ../../fcitx-${PN}/src/data/images/unix/ui-*.png; do
			newins "${image}" "mozc-${image#../../fcitx-${PN}/src/data/images/unix/ui-}"
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
