# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="amd64 x86"
	SRC_URI="https://www.bitbucket.org/${PN}/targz/downloads/${P}.tar.gz"
	HG_DEPEND=">=dev-vcs/mercurial-3.6 <dev-vcs/mercurial-3.8"
else
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/tortoisehg/thg"
	EHG_REVISION="stable"
	KEYWORDS=""
	SRC_URI=""
	HG_DEPEND="dev-vcs/mercurial"
fi

DESCRIPTION="Set of graphical tools for Mercurial"
HOMEPAGE="https://tortoisehg.bitbucket.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

RDEPEND="${HG_DEPEND}
	dev-python/iniparse[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/PyQt4[svg,${PYTHON_USEDEP}]
	dev-python/qscintilla-python[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-1.0.3 )"

# Workaround race condition in build_qt
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	if [[ ${LINGUAS+set} ]]; then
		cd i18n/tortoisehg || die
		local x y keep
		for x in *.po; do
			keep=false
			for y in ${LINGUAS}; do
				if [[ ${y} == ${x%.po}* ]]; then
					keep=true
					break
				fi
			done
			${keep} || rm "${x}" || die
		done
		cd "${S}" || die
	fi
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	distutils-r1_python_install_all
	dodoc doc/ReadMe*.txt doc/TODO contrib/mergetools.rc
	if use doc ; then
		dohtml -r doc/build/html/
	fi
	newicon -s scalable icons/scalable/apps/thg.svg thg_logo.svg
	domenu contrib/thg.desktop
}

pkg_postinst() {
	elog "When startup of ${PN} fails with an API version mismatch error"
	elog "between dev-python/sip and dev-python/PyQt4 please rebuild"
	elog "dev-python/qscintilla-python."
}
