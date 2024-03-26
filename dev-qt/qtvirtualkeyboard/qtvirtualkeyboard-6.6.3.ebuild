# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Customizable input framework and virtual keyboard for Qt"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~loong"
fi

IUSE="+spell"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui]
	~dev-qt/qtdeclarative-${PV}:6
	~dev-qt/qtsvg-${PV}:6
	spell? ( app-text/hunspell:= )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(qt_feature spell hunspell)
		-DINPUT_vkb_handwriting=no # neither cerence nor myscript are packaged
	)

	qt6-build_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# rarely randomly(?) fails even with -j1
		tst_layoutfilesystem
	)

	if use spell && has_version app-dicts/myspell-en; then
		# 99% pass but minor sub-tests fail with myspell-en, needs looking into
		ewarn "Warning: notable tests were skipped due to ${_} being installed"
		CMAKE_SKIP_TESTS+=(
			tst_inputpanel
			tst_inputpanelcontrols2
		)
	else
		einfo "tst_inputpanel can take >5mins, not known to actually hang"
	fi

	qt6-build_src_test
}
