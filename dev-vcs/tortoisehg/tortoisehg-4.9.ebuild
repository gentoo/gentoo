# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit desktop distutils-r1

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://www.bitbucket.org/${PN}/targz/downloads/${P}.tar.gz"
	HG_DEPEND=">=dev-vcs/mercurial-4.8 <dev-vcs/mercurial-4.10"
else
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/tortoisehg/thg"
	EHG_REVISION="stable"
	HG_DEPEND="dev-vcs/mercurial"
fi

DESCRIPTION="Set of graphical tools for Mercurial"
HOMEPAGE="https://tortoisehg.bitbucket.io/"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

RDEPEND="${HG_DEPEND}
	dev-python/iniparse[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/PyQt5[network,svg,${PYTHON_USEDEP}]
	>=dev-python/qscintilla-python-2.9.4:=[qt5(+),${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-1.0.3 )"

# Workaround race condition in build_qt
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	if [[ ${L10N+set} ]]; then
		cd i18n/tortoisehg || die
		local x y keep
		for x in *.po; do
			keep=false
			for y in ${L10N}; do
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

	# Remove file that collides with >=mercurial-4.0 (bug #599266).
	rm "${ED}"/usr/$(get_libdir)/${EPYTHON}/site-packages/hgext3rd/__init__.py \
		|| die
}

pkg_postinst() {
	elog "When startup of ${PN} fails with an API version mismatch error"
	elog "between dev-python/sip and dev-python/PyQt5 please rebuild"
	elog "dev-python/qscintilla-python."
}
