# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="cs da de fr ja pl ru sl uk zh-CN zh-TW"

inherit llvm qmake-utils virtualx xdg

DESCRIPTION="Lightweight IDE for C++/QML development centering around Qt"
HOMEPAGE="https://doc.qt.io/qtcreator/"
LICENSE="GPL-3"
SLOT="0"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://code.qt.io/${PN}/${PN}.git"
else
	MY_PV=${PV/_/-}
	MY_P=${PN}-opensource-src-${MY_PV}
	[[ ${MY_PV} == ${PV} ]] && MY_REL=official || MY_REL=development
	SRC_URI="https://download.qt.io/${MY_REL}_releases/${PN/-}/${PV%.*}/${MY_PV}/${MY_P}.tar.xz"
	KEYWORDS="amd64 ~arm ~x86"
	S=${WORKDIR}/${MY_P}
fi

# TODO: unbundle sqlite

QTC_PLUGINS=('android:android|qmakeandroidsupport' autotools:autotoolsprojectmanager baremetal bazaar
	'+clang:clangcodemodel|clangformat|clangtools' clearcase cmake:cmakeprojectmanager cppcheck
	cvs +designer git glsl:glsleditor +help ios lsp:languageclient mercurial modeling:modeleditor
	nim perforce python:pythoneditor qbs:qbsprojectmanager qnx scxml:scxmleditor serialterminal
	silversearcher subversion valgrind winrt)
IUSE="doc systemd test +webengine ${QTC_PLUGINS[@]%:*}"
RESTRICT="!test? ( test )"

# minimum Qt version required
QT_PV="5.9.0:5"

CDEPEND="
	=dev-libs/botan-2.9*:2=[-bindist]
	>=dev-qt/qtconcurrent-${QT_PV}
	>=dev-qt/qtcore-${QT_PV}
	>=dev-qt/qtdeclarative-${QT_PV}[widgets]
	>=dev-qt/qtgui-${QT_PV}
	>=dev-qt/qtnetwork-${QT_PV}[ssl]
	>=dev-qt/qtprintsupport-${QT_PV}
	>=dev-qt/qtquickcontrols-${QT_PV}
	>=dev-qt/qtscript-${QT_PV}
	>=dev-qt/qtsql-${QT_PV}[sqlite]
	>=dev-qt/qtsvg-${QT_PV}
	>=dev-qt/qtwidgets-${QT_PV}
	>=dev-qt/qtx11extras-${QT_PV}
	>=dev-qt/qtxml-${QT_PV}
	clang? ( >=sys-devel/clang-6:= )
	designer? ( >=dev-qt/designer-${QT_PV} )
	help? (
		>=dev-qt/qthelp-${QT_PV}
		webengine? ( >=dev-qt/qtwebengine-${QT_PV}[widgets] )
	)
	qbs? ( ~dev-util/qbs-1.12.2 )
	serialterminal? ( >=dev-qt/qtserialport-${QT_PV} )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="${CDEPEND}
	>=dev-qt/linguist-tools-${QT_PV}
	virtual/pkgconfig
	doc? ( >=dev-qt/qdoc-${QT_PV} )
	test? (
		>=dev-qt/qtdeclarative-${QT_PV}[localstorage]
		|| (
			>=dev-qt/qtxmlpatterns-5.12.1-r1:5[qml(+)]
			<dev-qt/qtdeclarative-5.12.0[xml]
		)
		>=dev-qt/qtquickcontrols2-${QT_PV}
		>=dev-qt/qttest-${QT_PV}
	)
"
RDEPEND="${CDEPEND}
	sys-devel/gdb[client,python]
	autotools? ( sys-devel/autoconf )
	bazaar? ( dev-vcs/bzr )
	cmake? ( dev-util/cmake[server(+)] )
	cppcheck? ( dev-util/cppcheck )
	cvs? ( dev-vcs/cvs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	silversearcher? ( sys-apps/the_silver_searcher )
	subversion? ( dev-vcs/subversion )
	valgrind? ( dev-util/valgrind )
"
# qt translations must also be installed or qt-creator translations won't be loaded
for x in ${PLOCALES}; do
	IUSE+=" l10n_${x}"
	RDEPEND+=" l10n_${x}? ( >=dev-qt/qttranslations-${QT_PV} )"
done
unset x

pkg_setup() {
	use clang && llvm_pkg_setup
}

src_prepare() {
	default

	# disable unwanted plugins
	for plugin in "${QTC_PLUGINS[@]#[+-]}"; do
		if ! use ${plugin%:*}; then
			einfo "Disabling ${plugin%:*} plugin"
			sed -i -re "/(^\s+|SUBDIRS\s*\+=\s*)(${plugin#*:})\>/d" \
				src/plugins/plugins.pro || die "failed to disable ${plugin%:*} plugin"
		fi
	done
	sed -i -e '/updateinfo/d' src/plugins/plugins.pro || die

	# avoid building unused support libraries and tools
	if ! use clang; then
		sed -i -e '/clangsupport/d' src/libs/libs.pro || die
		sed -i -e '/SUBDIRS += clangbackend/d' src/tools/tools.pro || die
	fi
	if ! use glsl; then
		sed -i -e '/glsl/d' src/libs/libs.pro || die
	fi
	if ! use lsp; then
		sed -i -e '/languageserverprotocol/d' src/libs/libs.pro tests/auto/auto.pro || die
	fi
	if ! use modeling; then
		sed -i -e '/modelinglib/d' src/libs/libs.pro || die
	fi
	if ! use valgrind; then
		sed -i -e '/valgrindfake/d' src/tools/tools.pro || die
		sed -i -e '/valgrind/d' tests/auto/auto.pro || die
	fi

	# automagic dep on qtwebengine
	if ! use webengine; then
		sed -i -e 's/isEmpty(QT\.webenginewidgets\.name)/true/' src/plugins/help/help.pro || die
	fi

	# disable broken or unreliable tests
	sed -i -e 's/\(manual\|tools\|unit\)//g' tests/tests.pro || die
	sed -i -e '/\(dumpers\|namedemangler\)\.pro/d' tests/auto/debugger/debugger.pro || die
	sed -i -e '/CONFIG -=/s/$/ testcase/' tests/auto/extensionsystem/pluginmanager/correctplugins1/plugin?/plugin?.pro || die

	# do not install test binaries
	sed -i -e '/CONFIG +=/s/$/ no_testcase_installs/' tests/auto/{qttest.pri,json/json.pro} || die

	# fix path to some clang headers
	sed -i -e "/^CLANG_RESOURCE_DIR\s*=/s:\$\${LLVM_LIBDIR}:${EPREFIX}/usr/lib:" src/shared/clang/clang_defines.pri || die

	# fix translations
	local lang languages=
	for lang in ${PLOCALES}; do
		use l10n_${lang} && languages+=" ${lang/-/_}"
	done
	sed -i -e "/^LANGUAGES\s*=/s:=.*:=${languages}:" share/qtcreator/translations/translations.pro || die

	# remove bundled botan
	rm -rf src/libs/3rdparty/botan || die

	# remove bundled qbs
	rm -rf src/shared/qbs || die
}

src_configure() {
	eqmake5 IDE_LIBRARY_BASENAME="$(get_libdir)" \
		IDE_PACKAGE_MODE=1 \
		$(use clang && echo LLVM_INSTALL_DIR="$(get_llvm_prefix)") \
		$(use qbs && echo QBS_INSTALL_DIR="${EPREFIX}/usr") \
		CONFIG+=qbs_disable_rpath \
		CONFIG+=qbs_enable_project_file_updates \
		CONFIG+=use_system_botan \
		$(use systemd && echo CONFIG+=journald) \
		$(use test && echo BUILD_TESTS=1)
}

src_test() {
	cd tests/auto && virtx default
}

src_install() {
	emake INSTALL_ROOT="${ED}usr" install

	dodoc dist/{changes-*,known-issues}

	# install documentation
	if use doc; then
		emake docs
		# don't use ${PF} or the doc will not be found
		insinto /usr/share/doc/qtcreator
		doins share/doc/qtcreator/qtcreator{,-dev}.qch
		docompress -x /usr/share/doc/qtcreator/qtcreator{,-dev}.qch
	fi
}
