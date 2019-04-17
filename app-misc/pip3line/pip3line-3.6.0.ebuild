# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit cmake-utils python-r1 python-utils-r1

DESCRIPTION="Raw bytes manipulation, transformations (decoding and more) and interception"
HOMEPAGE="https://github.com/metrodango/pip3line"

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/metrodango/pip3line.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/metrodango/pip3line/archive/v${PV}.tar.gz  -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

# A few comments
# the ssl flag is just there to enable the plugin for low level crypto algorithms. 
# It has nothing to do with the SSL/TLS protocol itself.

IUSE="distorm python qscintilla ssl"

RDEPEND="
	${PYTHON_DEPS}
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxmlpatterns:5
	qscintilla? ( x11-libs/qscintilla )
	ssl? ( dev-libs/openssl:0= )"

DEPEND="${RDEPEND}
	distorm? ( dev-vcs/git )"

src_configure() {

	local mycmakeargs=(
		-DBASIC=yes
		-DWITH_DISTORM=$(usex distorm)
		-DWITH_OPENSSL=$(usex ssl)
		-DWITH_SCINTILLA=$(usex qscintilla)
	)

	# distorm is statically linked, due to insufficiencies
	# in the current distorm64 package 

	if use distorm; then
		mycmakeargs+=(-DWITH_DISTORM_LINK_STATICALLY=ON)
	fi

	if use python; then
		local targets=( ${PYTHON_TARGETS} )
		for target in ${targets[@]}; do
			if python_is_python3 ${target}; then
				python_export ${target} PYTHON PYTHON_LIBPATH PYTHON_INCLUDEDIR
				mycmakeargs+=(-DWITH_PYTHON3=ON
					-DPYTHON3_INCLUDE_DIRS=${PYTHON_INCLUDEDIR}
					-DPYTHON3_LIBRARIES=${PYTHON_LIBPATH}
				)
				break
			fi
		done
		for target in ${targets[@]}; do
			if ! python_is_python3 ${target}; then
				python_export ${target} PYTHON PYTHON_LIBPATH PYTHON_INCLUDEDIR
				mycmakeargs+=(-DWITH_PYTHON27=ON
					-DPYTHON27_INCLUDE_DIRS=${PYTHON_INCLUDEDIR}
					-DPYTHON27_LIBRARIES=${PYTHON_LIBPATH}
				)
				break
			fi
		done
	fi

	cmake-utils_src_configure
}
