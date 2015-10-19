# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib qmake-utils

MY_P=${PN}-src-${PV}

DESCRIPTION="Qt Build Suite"
HOMEPAGE="http://wiki.qt.io/Qbs"
SRC_URI="http://download.qt.io/official_releases/${PN}/${PV}/${MY_P}.tar.gz"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="doc examples test"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtscript:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	doc? (
		dev-qt/qdoc:5
		dev-qt/qthelp:5
	)
	test? (
		dev-qt/qtdeclarative:5
		dev-qt/qttest:5
	)
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# disable tests that require nodejs (bug 527652)
	sed -i -e 's/!haveNodeJs()/true/' \
		tests/auto/blackbox/tst_blackbox.cpp || die

	if ! use examples; then
		sed -i -e '/INSTALLS +=/ s:examples::' static.pro || die
	fi

	if use test; then
		sed -i -e '/SUBDIRS =/ s:=.*:= auto:' tests/tests.pro || die
	else
		sed -i -e '/SUBDIRS =/ d' tests/tests.pro || die
	fi
}

src_configure() {
	local myqmakeargs=(
		qbs.pro # bug 523218
		-recursive
		CONFIG+=qbs_disable_rpath
		CONFIG+=qbs_enable_project_file_updates
		$(usex test 'CONFIG+=qbs_enable_unit_tests' '')
		QBS_INSTALL_PREFIX="${EPREFIX}/usr"
		QBS_LIBRARY_DIRNAME="$(get_libdir)"
	)
	eqmake5 "${myqmakeargs[@]}"
}

src_test() {
	einfo "Setting up test environment in ${T}"

	export HOME=${T}
	export LD_LIBRARY_PATH=${S}/$(get_libdir)

	"${S}"/bin/qbs-setup-toolchains "${EROOT}usr/bin/gcc" gcc || die
	"${S}"/bin/qbs-setup-qt "$(qt5_get_bindir)/qmake" qbs_autotests || die

	einfo "Running autotests"

	# simply exporting LD_LIBRARY_PATH doesn't work
	# we have to use a custom testrunner script
	local testrunner=${S}/gentoo-testrunner
	cat <<-EOF > "${testrunner}"
	#!/bin/sh
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\${LD_LIBRARY_PATH:+:}\${LD_LIBRARY_PATH}"
	exec "\$@"
	EOF
	chmod +x "${testrunner}"

	emake TESTRUNNER="'${testrunner}'" check
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	# install documentation
	if use doc; then
		emake docs
		dodoc -r doc/html
		dodoc doc/qbs.qch
		docompress -x /usr/share/doc/${PF}/qbs.qch
	fi
}
