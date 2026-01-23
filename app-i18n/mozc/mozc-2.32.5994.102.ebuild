# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit desktop dot-a edo elisp-common flag-o-matic multiprocessing python-any-r1 savedconfig toolchain-funcs xdg

# USE_BAZEL_VERSION in .bazeliskrc
BAZEL_VER="8.4.1"
# 2025-10-22, date of release of mozc
BAZEL_BCR_HASH="470a7a43196aeffd5f6c3ff41bbcfeb120a04341"
# commit: Merge "Update BUILD_OSS to 5994"
MOZC_FCITX_HASH="6c54b5d52a3a9d949502ad8e6c2eab2c66e7f1a7"

# submodules, but archives are fetched by bazel from bazel_dist
ABS_VER="20250814.0"
GTEST_VER="1.17.0"
JUD_VER="2025-01-25"
# sha256sum of tarball
JUD_CHECKSUM="ebfc8681eb207f14a2c36a7a71522b1aa8a405d10ab36a83a9a024d4ce58c0ca"
PROTO_VER="32.0"

# to simplify update
CPYTHON_VER="3.11.13+20250610"
RPYTHON_VER="1.5.4"

DESCRIPTION="Mozc - Japanese input method editor."
HOMEPAGE="https://github.com/google/mozc"
# for new release, update versions according to MODULE.bazel or failures of the fetch's phase of bazel
SRC_URI="
	amd64? (
		https://releases.bazel.build/${BAZEL_VER}/release/bazel-${BAZEL_VER}-linux-x86_64
		https://github.com/astral-sh/python-build-standalone/releases/download/${CPYTHON_VER#*+}/cpython-${CPYTHON_VER}-x86_64-unknown-linux-gnu-install_only.tar.gz
	)
	arm64? (
		https://releases.bazel.build/${BAZEL_VER}/release/bazel-${BAZEL_VER}-linux-arm64
		https://github.com/astral-sh/python-build-standalone/releases/download/${CPYTHON_VER#*+}/cpython-${CPYTHON_VER}-aarch64-unknown-linux-gnu-install_only.tar.gz
	)
	!fcitx5? ( https://github.com/google/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz )
	fcitx5? ( https://github.com/fcitx/${PN}/archive/${MOZC_FCITX_HASH}.tar.gz
		-> ${PN}-fcitx5-${PV}.tar.gz )
	test? ( https://github.com/google/googletest/releases/download/v${GTEST_VER}/googletest-${GTEST_VER}.tar.gz )
	https://github.com/bazelbuild/bazel-central-registry/archive/${BAZEL_BCR_HASH}.tar.gz
		-> ${PN}-bcr-${BAZEL_BCR_HASH}.tar.gz
	https://github.com/abseil/abseil-cpp/releases/download/${ABS_VER}/abseil-cpp-${ABS_VER}.tar.gz
	https://github.com/hiroyuki-komatsu/japanese-usage-dictionary/archive/${JUD_VER}.tar.gz
		-> japanese-usage-dictionary-${JUD_VER}.tar.gz
	https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VER}/protobuf-${PROTO_VER}.zip
	https://github.com/bazel-contrib/rules_python/releases/download/${RPYTHON_VER}/rules_python-${RPYTHON_VER}.tar.gz
	https://github.com/bazelbuild/apple_support/releases/download/1.23.1/apple_support.1.23.1.tar.gz
	https://github.com/bazel-contrib/bazel_features/releases/download/v1.30.0/bazel_features-v1.30.0.tar.gz
	https://github.com/bazelbuild/bazel-skylib/releases/download/1.8.1/bazel-skylib-1.8.1.tar.gz
	https://github.com/bazelbuild/platforms/releases/download/1.0.0/platforms-1.0.0.tar.gz
	https://github.com/bazelbuild/rules_android_ndk/releases/download/v0.1.3/rules_android_ndk-v0.1.3.tar.gz
	https://github.com/bazelbuild/rules_apple/releases/download/4.1.2/rules_apple.4.1.2.tar.gz
	https://github.com/bazelbuild/rules_cc/releases/download/0.2.2/rules_cc-0.2.2.tar.gz
	https://github.com/bazelbuild/rules_java/releases/download/8.14.0/rules_java-8.14.0.tar.gz
	https://github.com/bazelbuild/rules_kotlin/releases/download/v1.9.6/rules_kotlin-v1.9.6.tar.gz
	https://github.com/bazelbuild/rules_license/releases/download/1.0.0/rules_license-1.0.0.tar.gz
	https://github.com/bazelbuild/rules_pkg/releases/download/1.1.0/rules_pkg-1.1.0.tar.gz
	https://github.com/bazelbuild/rules_shell/releases/download/v0.3.0/rules_shell-v0.3.0.tar.gz
	https://github.com/bazelbuild/rules_swift/releases/download/3.1.2/rules_swift.3.1.2.tar.gz
	https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.gz
	https://github.com/hiroyuki-komatsu/japanpost_zipcode/raw/33524763837473258e7ba2f14b17fc3a70519831/ken_all.zip
		-> ${P}-ken_all.zip
	https://github.com/hiroyuki-komatsu/japanpost_zipcode/raw/33524763837473258e7ba2f14b17fc3a70519831/jigyosyo.zip
		-> ${P}-jigyosyo.zip
	https://raw.githubusercontent.com/google/material-design-icons/4.0.0/png/action/chrome_reader_mode/materialiconsoutlined/48dp/1x/outline_chrome_reader_mode_black_48dp.png
		-> ${P}-dictionary.png
	https://raw.githubusercontent.com/google/material-design-icons/4.0.0/src/action/chrome_reader_mode/materialiconsoutlined/24px.svg
		-> ${P}-dictionary.svg
	https://raw.githubusercontent.com/google/material-design-icons/4.0.0/png/action/settings/materialiconsround/48dp/1x/round_settings_black_48dp.png
		-> ${P}-properties.png
	https://raw.githubusercontent.com/google/material-design-icons/4.0.0/src/action/settings/materialiconsround/24px.svg
		-> ${P}-properties.svg
	https://raw.githubusercontent.com/google/material-design-icons/4.0.0/png/action/build/materialicons/48dp/1x/baseline_build_black_48dp.png
		-> ${P}-tool.png
	https://raw.githubusercontent.com/google/material-design-icons/4.0.0/src/action/build/materialicons/24px.svg
		-> ${P}-tool.svg
"
S="${WORKDIR}/${P}/src"

# Mozc: BSD
# src/data/dictionary_oss: ipadic, public-domain
# src/data/unicode: unicode
# japanese-usage-dictionary: BSD-2
LICENSE="BSD BSD-2 ipadic public-domain unicode"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="debug emacs fcitx5 +gui +ibus renderer test"
REQUIRED_USE="|| ( emacs fcitx5 ibus )"
RESTRICT="!test? ( test )"

DEPEND="
	fcitx5? ( app-i18n/fcitx:5 )
	gui? ( dev-qt/qtbase:6[gui,widgets] )
	ibus? (
		app-i18n/ibus
		dev-libs/glib:2
	)
	renderer? ( dev-qt/qtbase:6[gui,widgets] )
"
RDEPEND="${DEPEND}
	emacs? ( app-editors/emacs:* )
"
BDEPEND="
	${PYTHON_DEPS}
	app-arch/unzip
	virtual/pkgconfig
	fcitx5? ( sys-devel/gettext )
"

SITEFILE="50${PN}-gentoo.el"

PATCHES=(
	"${FILESDIR}"/${PN}-2.31.5851.102-fix_path.patch
	# from upstream
	"${FILESDIR}"/${PN}-2.32.5994.102-rm_reinterpret_cast.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_unpack() {
	case $(tc-arch) in
		amd64)		export EARCH=x86_64 ;;
		arm64)		export EARCH=arm64 ;;
		*)			die "architecture not supported: $(tc-arch)" ;;
	esac
	cp "${DISTDIR}"/bazel-${BAZEL_VER}-linux-${EARCH} bazel || die
	chmod +x bazel || die

	unpack ${PN}-bcr-${BAZEL_BCR_HASH}.tar.gz
	ln -sfT bazel-central-registry-${BAZEL_BCR_HASH} bcr || die

	# create symlinks for distdir with the name wanted by bazel
	mkdir bazel_dist || die
	pushd "${DISTDIR}" || die
	for dep in *.{tar.gz,zip,png,svg}; do
		ln -sfT "${DISTDIR}/${dep}" "${WORKDIR}/bazel_dist/${dep#${P}-}" || die
	done
	ln -sfT "${DISTDIR}"/japanese-usage-dictionary-${JUD_VER}.tar.gz "${WORKDIR}"/bazel_dist/${JUD_VER}.tar.gz  || die
	popd || die

	if use fcitx5; then
		unpack ${PN}-fcitx5-${PV}.tar.gz
		ln -sfT "${WORKDIR}"/${PN}-${MOZC_FCITX_HASH} "${WORKDIR}"/${P} || die
	else
		unpack ${P}.tar.gz
	fi
}

ebazel() {
	debug-print-function ${FUNCNAME} "${@}"

	edo "${WORKDIR}"/bazel "$@"
}

mozc_icons() {
	if use fcitx5 || use gui || use ibus; then
		return 0
	fi
}

src_prepare() {
	default

	# use tarball instead of zip for japanese-usage-dictionary (avoid CI failure)
	sed -e "/^ *name = \"ja_usage_dict\"/,/^ *sha256/s/sha256 =.*,$/sha256 = \"${JUD_CHECKSUM}\",/" \
		-e "\@.*github.com/hiroyuki-komatsu/japanese-usage-dictionary@s:%s.zip:%s.tar.gz:" \
		-i MODULE.bazel || die

	# declare a patch to bazel for rules_python
	cat >> MODULE.bazel <<-_EOF_ || die
		single_version_override(
			module_name = "rules_python",
			patches = [ "bazel/rules_python_fix_shebang.patch" ],
			version = "${RPYTHON_VER}",
		)
	_EOF_
	# 'install' the patch for rules_python
	# check py_runtime_info.bzl from ${WORKDIR}/bazel_dist/rules_python-${RPYTHON_VER}.tar.gz to update the patch
	cp "${FILESDIR}"/${PN}-2.32.5994.102-bazel_patch-fix_shebang.patch bazel/rules_python_fix_shebang.patch || die
	# fix shebang
	sed -e "s:@PYTHON@:${PYTHON}:" \
		-i bazel/rules_python_fix_shebang.patch || die

	# fix paths to preserve compatibility
	sed -e "/LINUX_MOZC_SERVER_DIR/s:=.*:= \"/usr/libexec/mozc\":" \
		-e "/IBUS_MOZC_PATH/s:=.*:= \"/usr/libexec/ibus-engine-mozc\":" \
		-i config.bzl || die

	# respect prefix
	if [[ -n ${EPREFIX} ]]; then
		sed	-e "s@/usr@${EPREFIX}/usr@" -i config.bzl || die
	fi

	# fix pkg-config for fcitx5 / ibus / glib / Qt
	tc-export PKG_CONFIG
	sed -e "s@\"pkg-config\"@\"${PKG_CONFIG}\"@" \
		-i bazel/pkg_config_repository.bzl || die

	# bug #877765
	restore_config mozcdic-ut.txt
	if [[ -f /mozcdic-ut.txt && -s mozcdic-ut.txt ]]; then
		einfo "mozcdic-ut.txt found. Adding to mozc dictionary..."
		cat mozcdic-ut.txt >> "${S}"/data/dictionary_oss/dictionary00.txt || die
	fi

	# custom the target 'package' defined in unix/BUILD.bazel
	if ! mozc_icons; then
		sed -e "\@:icons@d" \
			-i unix/BUILD.bazel || die
	fi

	if ! use emacs; then
		sed -e "\@//unix/emacs:mozc_emacs_helper@d" \
			-e "\@//unix/emacs:mozc.el@d" \
			-i unix/BUILD.bazel || die
	fi

	if ! use gui; then
		sed -e "\@//gui/tool:mozc_tool@d" \
			-i unix/BUILD.bazel || die
	fi

	if ! use ibus; then
		sed -e "\@//unix/ibus:gen_mozc_xml@d" \
			-e "\@//unix/ibus:ibus_mozc@d" \
			-i unix/BUILD.bazel || die
	fi

	if ! use renderer; then
		sed -e "\@//renderer/qt:mozc_renderer@d" \
			-i unix/BUILD.bazel || die
	fi
}

src_configure() {
	# to investigate, but there's lot of static libs
	lto-guarantee-fat

	# https://bazel.build/reference/be/make-variables
	tc-export CC AR

	# fix external/zlib+ w/ clang-21
	append-cppflags -DHAVE_UNISTD_H=1

	MYEBAZELARGS=(
		--compilation_mode="$(usex debug dbg opt)"
		--config="oss_linux"
		--distdir="${WORKDIR}/bazel_dist"
		--jobs="$(get_makeopts_jobs)"
		--registry="file://${WORKDIR}/bcr"
		--repository_cache="${WORKDIR}/bazel_cache"
		--spawn_strategy="local" # portage is already sandboxed
		--strip="$(usex debug never always)"
		--subcommands # be verbose
		--verbose_failures
	)

	if use fcitx5; then
		MYEBAZELARGS+=(
			unix/fcitx5/fcitx5-mozc.so
			# just to be sure, use_server is enabled by default
			--define server=1
		)
	fi

	# add all targets/testsuites by default, then filter
	if use test; then
		MYEBAZELARGS+=( /... )
		# not unix, no testsuite
		SKIP_TESTS=( -protocol/... )
		! use emacs && SKIP_TESTS+=( -unix/emacs/... )
		! use gui && SKIP_TESTS+=( -gui/... )
		! use ibus && SKIP_TESTS+=( -unix/ibus/... )
		! use renderer && SKIP_TESTS+=( -renderer/... )
		use fcitx5 && SKIP_TESTS+=( -unix/fcitx/... )
	fi

	local cppflags
	for cppflags in ${CPPFLAGS}; do
		MYEBAZELARGS+=( --copt="${cppflags}" )
	done

	local cflags
	for cflags in ${CFLAGS}; do
		MYEBAZELARGS+=( --conlyopt="${cflags}" )
	done

	local cxxflags
	for cxxflags in ${CXXFLAGS}; do
		MYEBAZELARGS+=( --cxxopt="${cxxflags}" )
	done

	local ldflags
	for ldflags in ${LDFLAGS}; do
		MYEBAZELARGS+=( --linkopt="${ldflags}" )
	done

	# clean cache, just in case
	ebazel clean --expunge

	# this build --nobuild generates bazel_cache
	# this is useful to debug or make patch
	ebazel build --nobuild package "${MYEBAZELARGS[@]}" -- "${SKIP_TESTS[@]}"
}

src_compile() {
	ebazel build package "${MYEBAZELARGS[@]}" -- "${SKIP_TESTS[@]}"

	# bazel-bin is a symlink, copy files to avoid problem with symlink then
	cp -R bazel-bin/unix out_linux || die

	use emacs && elisp-compile unix/emacs/*.el
}

src_test() {
	ebazel test --build_tests_only "${MYEBAZELARGS[@]}" -- "${SKIP_TESTS[@]}"
}

src_install() {
	unzip -qo out_linux/mozc.zip -d "${ED}" || die

	# remove mozc.el, in a wrong path
	# already compiled elsewhere and installed then
	if use emacs; then
		rm -r "${ED}"/usr/share/emacs/site-lisp/emacs-mozc || die
		elisp-install ${PN} unix/emacs/*.{el,elc}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} ${PN}
	fi

	if mozc_icons; then
		# remove tmp with duplicate icons zipped
		rm -r "${ED}"/tmp || die
		if ! use ibus; then
			rm -r "${ED}"/usr/share/ibus-mozc || die
		fi
		if ! use gui; then
			rm -r "${ED}"/usr/share/icons/mozc || die
		fi
	fi

	if use fcitx5; then
		exeinto /usr/$(get_libdir)/fcitx5
		doexe out_linux/fcitx5/fcitx5-mozc.so

		# see scripts/install_fcitx5_data
		insinto /usr/share/fcitx5/addon
		newins unix/fcitx5/mozc-addon.conf mozc.conf

		insinto /usr/share/fcitx5/inputmethod
		doins unix/fcitx5/mozc.conf

		export MOPREFIX="fcitx5-mozc"
		local mo_file
		for mo_file in unix/fcitx5/po/*.po; do
			msgfmt "${mo_file}" -o "${mo_file%.po}.mo" && domo "${mo_file%.po}.mo"  || die
		done

		msgfmt --xml -d unix/fcitx5/po/ \
			--template unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml.in \
			-o unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml || die
		insinto /usr/share/metainfo
		doins unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml

		# see scripts/install_fcitx5_icons
		local orgfcitx5="org.fcitx.Fcitx5.fcitx-mozc"
		newicon -s 128 data/images/product_icon_32bpp-128.png ${orgfcitx5}.png
		newicon -s 128 data/images/product_icon_32bpp-128.png fcitx-mozc.png
		newicon -s 32 data/images/unix/ime_product_icon_opensource-32.png ${orgfcitx5}.png
		newicon -s 32 data/images/unix/ime_product_icon_opensource-32.png fcitx-mozc.png
		for uiimg in ../scripts/icons/ui-*.png; do
			dimg="${uiimg#*ui-}"
			newicon -s 48 "${uiimg}" "${orgfcitx5}-${dimg/_/-}"
			newicon -s 48 "${uiimg}" "fcitx-mozc-${dimg/_/-}"
		done
	fi

	[[ -s mozcdic-ut.txt ]] && save_config mozcdic-ut.txt

	insinto /usr/libexec/mozc/documents
	doins data/installer/credits_en.html
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
	xdg_pkg_postinst
}

pkg_postrm() {
	if use emacs; then
		elisp-site-regen
	fi
	xdg_pkg_postrm
}
