# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="88bb0fcdaab5bdd1176a3b6b485a6415a137ec27"

inherit qmake-utils

DESCRIPTION="A cross-platform IRC framework written with Qt"
HOMEPAGE="https://communi.github.io/"
SRC_URI="https://github.com/communi/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples qml test +uchardet"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	examples? ( dev-qt/qtgui:5[xcb] )
	uchardet? ( app-i18n/uchardet )
	!uchardet? ( dev-libs/icu:= )
"

DEPEND="
	${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default

	# Currently the test tst_IrcLagTimer fails, so disabling
	# See: https://github.com/communi/libcommuni/issues/63
	sed -e '/irclagtimer/d' -i tests/auto/auto.pro || die
}

src_configure() {
	local myqmakeargs=( libcommuni.pro
		# Disables compile run-time benchmarks, as they don't make any sense
		-config no_benchmarks
		# Is needed for fixing the QA Notice: The following files contain insecure RUNPATHs
		-config no_rpath
		# Compile libcommuni always in Release mode, as Debug seems to do nothing
		-config release
		# Don't silence all compile messages
		-config verbose
		-config $(usex examples '' 'no_')examples
		-config $(usex qml '' 'no_')install_imports
		-config $(usex qml '' 'no_')install_qml
		-config $(usex test '' 'no_')tests
		-config $(usex uchardet 'no_' '')icu
		-config $(usex uchardet '' 'no_')uchardet )

	eqmake5 "${myqmakeargs[@]}"
}

src_test() {
	# This is a hack to delete the existing LD_LIBRARY_PATH and set a new one,
	# otherwise a test will fail, because it uses the system installed lib instead of the new compiled lib.
	# The test will fail, when libcommuni is emerged with USE="uchardet" and
	# libcommuni is already installed with USE="-uchardat", or the other way around.
	find "${S}" -type f -name 'target_wrapper.sh' -exec sed -i -e "/.*LD_LIBRARY_PATH.*/d" {} \; || die
	local -x LD_LIBRARY_PATH="${S}/lib"

	default
}

src_install() {
	emake install INSTALL_ROOT="${D}"

	if use examples; then
		local examples=( "bot" "client" "minimal" "qmlbot" "quick" )
		for example in ${examples[@]}; do
			newbin examples/"${example}"/"${example}" libcommuni."${example}"
		done
	fi

	einstalldocs
}
