# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite,threads"

inherit eutils gnome2-utils python-r1

DESCRIPTION="Python Fitting Assistant - a ship fitting application for EVE Online"
HOMEPAGE="https://github.com/pyfa-org/Pyfa"

LICENSE="GPL-3+ LGPL-2.1+ CC-BY-2.5 free-noncomm"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/pyfa-org/Pyfa.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/pyfa-org/Pyfa/archive/v${PV}.tar.gz -> pyfa-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi
IUSE="+graph"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	graph? (
		dev-python/matplotlib[wxwidgets,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}] )
	${PYTHON_DEPS}"
DEPEND="app-arch/zip"

[[ ${PV} = 9999 ]] || S=${WORKDIR}/Pyfa-${PV}

src_prepare() {
	# get rid of CRLF line endings introduced in 1.1.10 so patches work
	edos2unix config.py pyfa.py service/settings.py

	# load gameDB and images from separate staticdata directory
	eapply "${FILESDIR}/${PN}-1.15.1-staticdata.patch"

	# do not try to save exported html to python sitedir
	eapply "${FILESDIR}/${PN}-1.20.2-html-export-path.patch"

	# fix import path in the main script for systemwide installation
	eapply "${FILESDIR}/${PN}-1.15.1-import-pyfa.patch"

	eapply_user

	touch __init__.py

	pyfa_make_configforced() {
		mkdir -p "${BUILD_DIR}" || die
		sed -e "s:%%SITEDIR%%:$(python_get_sitedir):" \
			-e "s:%%EPREFIX%%:${EPREFIX}:" \
			"${FILESDIR}/configforced-1.15.1.py" > "${BUILD_DIR}/configforced.py"
		sed -e "s:%%SITEDIR%%:$(python_get_sitedir):" \
			pyfa.py > "${BUILD_DIR}/pyfa"
	}
	python_foreach_impl pyfa_make_configforced
}

src_install() {
	pyfa_py_install() {
		local packagedir=$(python_get_sitedir)/${PN}
		insinto "${packagedir}"
		doins -r eos gui service utils config*.py __init__.py
		[[ -e info.py ]] && doins info.py # only in zip releases
		doins "${BUILD_DIR}/configforced.py"
		python_doscript "${BUILD_DIR}/pyfa"
		python_optimize
	}
	python_foreach_impl pyfa_py_install

	insinto /usr/share/${PN}
	doins eve.db

	einfo "Compressing images ..."
	pushd imgs > /dev/null || die
	zip -r imgs.zip * || die "zip failed"
	doins imgs.zip
	popd > /dev/null || die

	dodoc README.md
	insinto /usr/share/icons/hicolor/32x32/apps
	doins imgs/gui/pyfa.png
	insinto /usr/share/icons/hicolor/64x64/apps
	newins imgs/gui/pyfa64.png pyfa.png
	domenu "${FILESDIR}/${PN}.desktop"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
