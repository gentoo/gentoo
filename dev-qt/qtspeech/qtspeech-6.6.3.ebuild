# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Text-to-speech library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong"
fi

IUSE="flite qml +speechd"
# can build with neither, but then it is just mock tts and may be confusing
REQUIRED_USE="|| ( flite speechd )"

# TODO: tests are known failing with clang and needs looking into, albeit
# it is still usable at runtime save for applications segfaulting on exit
# similarly to QTBUG-90626 (not that this has in-tree revdeps as of writing
# of this). Restricting because also seen this result in hanging. Note that
# qtspeech:6 is still somewhat new (started in 6.4.0), and should review
# status on new major versions.
RESTRICT="test"

RDEPEND="
	~dev-qt/qtbase-${PV}:6
	~dev-qt/qtmultimedia-${PV}:6
	flite? ( app-accessibility/flite )
	qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
	speechd? ( app-accessibility/speech-dispatcher )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
		$(qt_feature flite)
		$(qt_feature speechd)

		# flite_alsa was likely to work around old issues in flite, it does
		# nothing but add -lasound (no code change, and is unneeded)
		-DQT_FEATURE_flite_alsa=OFF
	)

	qt6-build_src_configure
}
