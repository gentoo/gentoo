#!/bin/bash
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

test_xfont_config_use_x_disabled() {
	tbegin "font_xfont_config no-op when in_iuse X && ! use X"
	(
		called=0
		mkfontscale() { called=1; }
		mkfontdir() { called=1; }
		inherit font
		# IUSE contains X by default, but use X is false (in tests-common use checks IUSE, override use)
		use() { return 1; }
		in_iuse() { return 0; }
		font_xfont_config
		[[ ${called} -eq 0 ]]
	)
	tend $?
}

test_xfont_config_use_x_enabled() {
	tbegin "font_xfont_config executes when in_iuse X && use X"
	(
		called_scale=0
		called_dir=0
		mkfontscale() { called_scale=1; }
		mkfontdir() { called_dir=1; }
		inherit font
		use() { return 0; }
		in_iuse() { return 0; }
		mkdir -p "${ED}${FONTDIR}"
		font_xfont_config
		[[ ${called_scale} -eq 1 && ${called_dir} -eq 1 ]]
	)
	tend $?
}

test_xfont_config_no_iuse_x() {
	tbegin "font_xfont_config no-op when X not in IUSE (FONT_AUTO_DEPEND=no)"
	(
		called_scale=0
		called_dir=0
		mkfontscale() { called_scale=1; }
		mkfontdir() { called_dir=1; }
		FONT_AUTO_DEPEND=no
		inherit font
		mkdir -p "${ED}${FONTDIR}"
		font_xfont_config
		[[ ${called_scale} -eq 0 && ${called_dir} -eq 0 ]]
	)
	tend $?
}

test_src_install_opt_out() {
	tbegin "font_src_install with FONT_AUTO_DEPEND=no does not call font_xfont_config"
	(
		called=0
		mkfontscale() { called=1; }
		mkfontdir() { called=1; }
		FONT_AUTO_DEPEND=no
		FONT_SUFFIX="ttf"
		FONT_PN="testfont"
		FONTDIR="/usr/share/fonts/testfont"
		S="${WORKDIR}/testfont"
		mkdir -p "${S}"
		touch "${S}/test.ttf"
		inherit font
		einstalldocs() { :; }
		font_src_install
		[[ -f "${ED}${FONTDIR}/test.ttf" ]] || exit 1
		[[ ${called} -eq 0 ]]
	)
	tend $?
}

test_src_install_use_x() {
	tbegin "font_src_install with default FONT_AUTO_DEPEND calls font_xfont_config when USE=X"
	(
		called=0
		mkfontscale() { called=1; }
		mkfontdir() { called=1; }
		FONT_SUFFIX="ttf"
		FONT_PN="testfont"
		FONTDIR="/usr/share/fonts/testfont"
		S="${WORKDIR}/testfont"
		mkdir -p "${S}"
		touch "${S}/test.ttf"
		inherit font
		use() { [[ $1 == "X" ]] && return 0; return 1; }
		in_iuse() { [[ $1 == "X" ]] && return 0; return 1; }
		einstalldocs() { :; }
		font_src_install
		[[ -f "${ED}${FONTDIR}/test.ttf" ]] || exit 1
		[[ ${called} -eq 1 ]]
	)
	tend $?
}

test_bdf_to_otb() {
	tbegin "font_bdf_to_otb converts single and multiple BDF files"
	(
		local args=()
		EAPI=9
		inherit font
		fonttosfnt() { args=( "$@" ); touch "$3"; }
		mkdir -p "${T}/otb_test"
		touch "${T}/otb_test/a.bdf" "${T}/otb_test/b.bdf"
		font_bdf_to_otb "${T}/otb_test/out.otb" "${T}/otb_test/a.bdf" "${T}/otb_test/b.bdf"
		[[ "${args[*]}" == "-v -o ${T}/otb_test/out.otb -- ${T}/otb_test/a.bdf ${T}/otb_test/b.bdf" ]]
	)
	tend $?

	tbegin "font_bdf_to_otb reads from stdin when no files given"
	(
		local args=() stdin_content=""
		EAPI=9
		inherit font
		fonttosfnt() { args=( "$@" ); stdin_content=$(cat); touch "$3"; }
		mkdir -p "${T}/otb_test"
		font_bdf_to_otb "${T}/otb_test/stdin.otb" <<< "DUMMY_BDF"
		[[ "${args[*]}" == "-v -o ${T}/otb_test/stdin.otb" && "${stdin_content}" == "DUMMY_BDF" ]]
	)
	tend $?
}

test_src_compile_otb() {
	tbegin "font_src_compile converts BDF and BDF.GZ to OTB in EAPI 9"
	(
		EAPI=9
		FONT_OPENTYPE_COMPAT=1
		FONT_SUFFIX="bdf"
		FONT_PN="testbdf"
		S="${WORKDIR}/testbdf"
		mkdir -p "${S}"
		touch "${S}/test.bdf"
		echo "TEST_GZ" | gzip -c > "${S}/test_gz.bdf.gz"
		inherit font
		fonttosfnt() { touch "$3"; }
		use() { [[ $1 == "opentype-compat" ]] && return 0; return 1; }
		in_iuse() { [[ $1 == "opentype-compat" ]] && return 0; return 1; }
		font_src_compile
		[[ -f "${S}/test.otb" && -f "${S}/test_gz.otb" ]] || exit 1
		[[ ${FONT_SUFFIX} == "bdf otb" ]] || exit 1
	)
	tend $?
}

test_src_install_eapi9_vs_eapi8() {
	tbegin "font_src_install in EAPI 9 does not run font_wrap_opentype_compat"
	(
		wrap_called=0
		EAPI=9
		FONT_OPENTYPE_COMPAT=1
		FONT_SUFFIX="otb"
		FONT_PN="testbdf"
		FONTDIR="/usr/share/fonts/testbdf"
		S="${WORKDIR}/testbdf"
		mkdir -p "${S}"
		touch "${S}/test.otb"
		inherit font
		font_wrap_opentype_compat() { wrap_called=1; }
		use() { [[ $1 == "opentype-compat" ]] && return 0; return 1; }
		in_iuse() { [[ $1 == "opentype-compat" ]] && return 0; return 1; }
		einstalldocs() { :; }
		font_src_install
		[[ ${wrap_called} -eq 0 ]]
	)
	tend $?

	tbegin "font_src_install in EAPI 8 runs font_wrap_opentype_compat"
	(
		wrap_called=0
		EAPI=8
		FONT_OPENTYPE_COMPAT=1
		FONT_SUFFIX="bdf"
		FONT_PN="testbdf"
		FONTDIR="/usr/share/fonts/testbdf"
		S="${WORKDIR}/testbdf"
		mkdir -p "${S}"
		touch "${S}/test.bdf"
		inherit font
		font_wrap_opentype_compat() { wrap_called=1; }
		use() { [[ $1 == "opentype-compat" ]] && return 0; return 1; }
		in_iuse() { [[ $1 == "opentype-compat" ]] && return 0; return 1; }
		einstalldocs() { :; }
		font_src_install
		[[ ${wrap_called} -eq 1 ]]
	)
	tend $?
}

test_src_compile_eapi_guard() {
	tbegin "font_src_compile dies in EAPI 8"
	(
		EAPI=8
		inherit font
		( font_src_compile 2>/dev/null ) && exit 1
		exit 0
	)
	tend $?
}

test_xfont_config_use_x_disabled
test_xfont_config_use_x_enabled
test_xfont_config_no_iuse_x
test_src_install_opt_out
test_src_install_use_x
test_bdf_to_otb
test_src_compile_eapi_guard
test_src_compile_otb
test_src_install_eapi9_vs_eapi8

texit
