# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Inter-Process Communication (IPC) library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64"
fi

IUSE="qml"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[network]
	qml? (
		~dev-qt/qtbase-${PV}:6[gui]
		~dev-qt/qtdeclarative-${PV}:6
	)
"
DEPEND="
	${RDEPEND}
	test? ( ~dev-qt/qtbase-${PV}:6[gui] )
"

src_configure() {
	# same issue as bug #913692 when tests are enabled
	has_version "=dev-qt/qtdeclarative-$(ver_cut 1-3)*:6" &&
		local mycmakeargs=( $(cmake_use_find_package qml Qt6Qml) )

	qt6-build_src_configure
}

src_test() {
	# tests re-use 127.0.0.1:65213 and randomly fail if ran at same time
	qt6-build_src_test -j1
}

src_install() {
	qt6-build_src_install

	if use test; then
		# installs 30+ test binaries like "qt6/bin/state" and, given
		# otherwise empty, "can" delete the directory rather than list
		rm -r -- "${D}${QT6_BINDIR}" || die
	fi
}
