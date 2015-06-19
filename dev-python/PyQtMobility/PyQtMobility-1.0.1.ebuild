# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyQtMobility/PyQtMobility-1.0.1.ebuild,v 1.3 2013/03/03 00:36:34 hwoarang Exp $

EAPI=4

PYTHON_DEPEND="*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython 2.7-pypy-*"

inherit python

MY_P=${PN}-gpl-${PV}

DESCRIPTION="Python bindings for Nokia's QtMobility libraries"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/pyqtmobility/intro"
SRC_URI="http://www.riverbankcomputing.co.uk/static/Downloads/${PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~amd64"

PYQTM_MODULES="+contacts feedback gallery location messaging multimedia organizer
		publishsubscribe sensors serviceframework systeminfo versit"
IUSE="debug ${PYQTM_MODULES}"

REQUIRED_USE="
	|| ( ${PYQTM_MODULES//+} )
	versit? ( contacts )
"

QTM_USE_DEPS=
for mod in ${PYQTM_MODULES//+}; do
	QTM_USE_DEPS+="${mod}?,"
done
unset mod

DEPEND="
	>=dev-python/sip-4.12.2
	>=dev-python/PyQt4-4.8.4[X]
	>=dev-qt/qt-mobility-1.2.0[${QTM_USE_DEPS%,}]
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# Disable pre-stripping of modules
	sed -i -e '/SIPModuleMakefile/s|$|strip=0,|' configure.py || die

	python_src_prepare
}

pyqtm_use_enable() {
	use $1 && echo --enable=${2:-Qt$(echo ${1:0:1} | tr '[:lower:]' '[:upper:]')${1:1}}
}

src_configure() {
	configuration() {
		local myconf=("$(PYTHON)"
			configure.py
			--destdir="${EPREFIX}$(python_get_sitedir)"
			--sipdir="${EPREFIX}/usr/share/sip"
			$(use debug && echo --debug)
			$(pyqtm_use_enable contacts)
			$(pyqtm_use_enable feedback)
			$(pyqtm_use_enable gallery)
			$(pyqtm_use_enable location)
			$(pyqtm_use_enable messaging)
			$(pyqtm_use_enable multimedia QtMultimediaKit)
			$(pyqtm_use_enable organizer)
			$(pyqtm_use_enable publishsubscribe QtPublishSubscribe)
			$(pyqtm_use_enable sensors)
			$(pyqtm_use_enable serviceframework QtServiceFramework)
			$(pyqtm_use_enable systeminfo QtSystemInfo)
			$(pyqtm_use_enable versit)
		)
		echo "${myconf[@]}"
		"${myconf[@]}"
	}
	python_execute_function -s configuration
}

pkg_postinst() {
	python_mod_optimize QtMobility
}

pkg_postrm() {
	python_mod_cleanup QtMobility
}
