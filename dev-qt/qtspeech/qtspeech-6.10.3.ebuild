# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# tests are kind of flaky, sometimes hang, and also fail with clang
# (not that it's unusable with clang) -- may be worth revisiting
# eventually given qtspeech is still somewhat new (added in 6.4.0)
QT6_RESTRICT_TESTS=1

inherit qt6-build

DESCRIPTION="Text-to-speech library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE="flite qml +speechd"

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
	)

	qt6-build_src_configure
}
