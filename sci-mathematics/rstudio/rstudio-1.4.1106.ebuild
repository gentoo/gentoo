# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake java-pkg-2 java-ant-2 multiprocessing pam qmake-utils xdg-utils

QT_VER=5.12.6
QT_SLOT=5

DESCRIPTION="IDE for the R language"
HOMEPAGE="
	https://rstudio.com
	https://github.com/rstudio/rstudio/"
SRC_URI="
	https://github.com/rstudio/rstudio/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://s3.amazonaws.com/rstudio-dictionaries/core-dictionaries.zip -> ${P}-core-dictionaries.zip
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="headless server test"
REQUIRED_USE="headless? ( server )"
# The test require an R package to be installed called `testthat`. I was able to
# install this using R itself via:
# ```sh
# $ R
# > install.packages("testthat")
# // select a CRAN mirror
# ```
# Using this locally installed "testthat", I got the following results from the
# test suite. It's unclear to me if the failures are from upstream or due to the
# gentoo packaging. I don't really have the motivation to continue improving on
# this, however I did want to leave this here for anyone who may be more
# interested in the future.
# [ FAIL 7 | WARN 6 | SKIP 2 | PASS 980 ]
RESTRICT="test"

RDEPEND="
	dev-db/postgresql:*
	dev-db/sqlite
	dev-java/aopalliance:1
	dev-java/gin:2.1
	dev-java/javax-inject
	=dev-java/validation-api-1.0*:1.0[source]
	>=dev-lang/R-3.0.1
	>=dev-libs/boost-1.69:=
	>=dev-libs/mathjax-2.7
	dev-libs/soci[postgres]
	net-libs/nodejs
	sys-process/lsof
	>=virtual/jdk-1.8:=
	!headless? (
		>=dev-qt/qtcore-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtdbus-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtdeclarative-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtnetwork-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtopengl-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtpositioning-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtsensors-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtsql-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtsvg-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtwebchannel-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtwebengine-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtxml-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtxmlpatterns-${QT_VER}:${QT_SLOT}
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.1106-ant-system-node.patch"
	"${FILESDIR}/${PN}-1.4.1106-boost-imports-and-namespaces.patch"
	"${FILESDIR}/${PN}-1.4.1106-check-test-failure.patch"
	"${FILESDIR}/${PN}-1.4.1106-cmake-bundled-dependencies.patch"
	"${FILESDIR}/${PN}-1.4.1106-fix-boost-version-check.patch"
	"${FILESDIR}/${PN}-1.4.1106-prefix-executable-names.patch"
	"${FILESDIR}/${PN}-1.4.1106-resource-path.patch"
	"${FILESDIR}/${PN}-1.4.1106-server-paths.patch"
	"${FILESDIR}/${PN}-1.4.1106-soci-cmake-find_library.patch"
)

src_unpack() {
	local dict_archive_name="${P}-core-dictionaries.zip"
	local ARCHIVE=""

	# rstudio's build-system expects these dictionary files to exist, but does
	# not ship them in the release tarball. Therefore, they are fetched in
	# `SRC_URI`, and here we unpack and move them to the correct place.
	for ARCHIVE in ${A}
	do
		if [[ ${ARCHIVE:-${#dict_archive_name}} == "${dict_archive_name}" ]]; then
			# unpack unzips the files as-is, and the zip from upstream isn't in
			# a sub-directory. We'll create a subdirectory and then unpack in
			# there in order to keep track of where these are.
			mkdir "${WORKDIR}/dictionaries" || die
			pushd "${WORKDIR}/dictionaries" > /dev/null || die
			unpack ${ARCHIVE}
			popd > /dev/null || die
		else
			unpack ${ARCHIVE}
		fi
	done
}

src_prepare() {
	cmake_src_prepare
	java-pkg-2_src_prepare

	# move the dictionary files to the expected place
	mkdir -p "${S}/dependencies/common" || die
	mv "${WORKDIR}/dictionaries" "${S}/dependencies/common" || die
}

src_configure() {
	export RSTUDIO_VERSION_MAJOR=$(ver_cut 1)
	export RSTUDIO_VERSION_MINOR=$(ver_cut 2)
	export RSTUDIO_VERSION_PATCH=$(ver_cut 3)

	# The cmake configurations allow installing either or both of a Desktop
	# component (i.e. a graphical front-end written in Qt) or a Server component
	# (i.e. a background process that is accessed remotely, via a browser or
	# some such).
	local RSTUDIO_BUILD_TYPE=""
	if use headless; then
		RSTUDIO_BUILD_TYPE="Server"
	else
		if use server; then
			# the "Development" target will install both
			RSTUDIO_BUILD_TYPE="Development"
		else
			RSTUDIO_BUILD_TYPE="Desktop"
		fi
	fi

	# FIXME: GWT_COPY is helpful because it allows us to call ant ourselves
	# (rather than using the custom_target defined in src/gwt/CMakeLists.txt),
	# however it also installs a test script, which we probably don't want.
	local mycmakeargs=(
		-DRSTUDIO_INSTALL_SUPPORTING=${EPREFIX}/usr/share/${PN}
		-DRSTUDIO_TARGET=${RSTUDIO_BUILD_TYPE}
		-DRSTUDIO_UNIT_TESTS_DISABLED=$(usex test OFF ON)
		-DRSTUDIO_USE_SYSTEM_BOOST=ON
		-DGWT_BUILD=OFF
		-DGWT_COPY=ON
	)

	if ! use headless; then
		mycmakeargs+=( -DQT_QMAKE_EXECUTABLE="$(qt5_get_bindir)/qmake" )
	fi

	# It looks like eant takes care of this for us during src_compile
	# TODO: verify with someone who knows better
	# java-ant-2_src_configure
	cmake_src_configure
}

src_compile() {
	export EANT_BUILD_XML="src/gwt/build.xml"
	export EANT_BUILD_TARGET="build"
	export ANT_OPTS="-Duser.home=${T} -Djava.util.prefs.userRoot=${T}"

	# FIXME: isn't there a variable we can use in one of the java eclasses that
	# will take care of some of the dependency and path stuff for us?
	local eant_extra_args=(
		# These are from src/gwt/CMakeLists.txt, grep if(GWT_BUILD)
		-Dbuild.dir="bin"
		-Dwww.dir="www"
		-Dextras.dir="extras"
		-Dlib.dir="lib"
		-Dgwt.main.module="org.rstudio.studio.RStudio"
		# These are added by me, to make things work
		-Dnode.bin="${EPREFIX}/bin/node"
		-Daopalliance.sdk="${EPREFIX}/share/aopalliance-1/lib"
		-Dgin.sdk="${EPREFIX}/share/gin-2.1/lib"
		-Djavax.inject="${EPREFIX}/share/javax-inject/lib"
		-Dvalidation.api="${EPREFIX}/share/validation-api-1.0/lib"
		-Dvalidation.api.sources="${EPREFIX}/share/validation-api-1.0/sources"
		# These are added as improvements, but are not strictly necessary
		# -Dgwt.extra.args='-incremental' # actually, it fails to build with # this
		-DlocalWorkers=$(makeopts_jobs)
	)

	local EANT_EXTRA_ARGS="${eant_extra_args[@]}"
	java-pkg-2_src_compile

	cmake_src_compile
}

src_install() {
	cmake_src_install

	if use server;then
		dopamd src/cpp/server/extras/pam/rstudio
		newinitd "${FILESDIR}/rstudio-server.initd" rstudio-server
	fi

	# This binary name is much to generic, so we'll change it
	mv "${D}/${EPREFIX}/usr/bin/diagnostics" "${D}/${EPREFIX}"
}

src_test() {
	# There is a gwt test suite, but it seems to require network access
	# export EANT_TEST_TARGET="unittest"
	# java-pkg-2_src_test

	mkdir -p ${HOME}/.local/share/rstudio || die
	cd ${BUILD_DIR}/src/cpp || die
	./rstudio-tests || die
}

pkg_preinst() {
	java-pkg-2_pkg_preinst
}
