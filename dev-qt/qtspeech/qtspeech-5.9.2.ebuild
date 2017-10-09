# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="Text-to-speech library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

# TODO: flite plugin - needs 2.0.0 (not yet in tree)
IUSE="examples"

RDEPEND="
	app-accessibility/speech-dispatcher
	~dev-qt/qtcore-${PV}
	examples? (
		~dev-qt/qtwidgets-${PV}
	)
"
DEPEND="${RDEPEND}"

QT5_EXAMPLES_SUBDIRS=(
	examples
)
