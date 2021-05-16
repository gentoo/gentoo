# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_SINGLE_IMPL=true
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1 readme.gentoo-r1 virtualx xdg-utils

DESCRIPTION="The highly caffeinated git GUI"
HOMEPAGE="https://git-cola.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		dev-python/pygments[${PYTHON_MULTI_USEDEP}]
		dev-python/PyQt5[network,${PYTHON_USEDEP}]
		dev-python/QtPy[gui,${PYTHON_MULTI_USEDEP}]
		dev-python/send2trash[${PYTHON_MULTI_USEDEP}]
	')
	dev-vcs/git
"
BDEPEND="sys-devel/gettext
	$(python_gen_cond_dep "
		doc? ( dev-python/sphinx[\${PYTHON_MULTI_USEDEP}] )
		test? (
			${VIRTUALX_DEPEND}
			dev-python/mock[\${PYTHON_MULTI_USEDEP}]
			dev-python/nose[\${PYTHON_MULTI_USEDEP}]
			dev-python/pytest[\${PYTHON_MULTI_USEDEP}]
		)
	")
"

python_prepare_all() {
	# make sure that tests also use the system provided QtPy
	rm -r qtpy || die

	rm share/git-cola/bin/*askpass* || die

	# don't install docs into wrong location
	sed -i -e '/doc/d' setup.py || die

	# fix doc directory reference
	sed -i \
		-e "s/'doc', 'git-cola'/'doc', '${PF}'/" \
		cola/resources.py || die

	# fix ssh-askpass directory reference
	sed -i -e 's/resources\.share/resources\.prefix/' cola/app.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	mydistutilsargs=( --no-vendor-libs --no-private-libs )
}

python_compile_all() {
	cd share/doc/${PN}/ || die
	if use doc ; then
		emake all
	else
		sed \
			-e '/^install:/s:install-html::g' \
			-e '/^install:/s:install-man::g' \
			-i Makefile || die
	fi
}

python_test() {
	GIT_CONFIG_NOSYSTEM=true \
	PYTHONPATH="${S}:${S}/build/lib:${PYTHONPATH}" LC_ALL="C.utf8" \
	virtx nosetests --verbose --with-id --with-doctest \
		--exclude=sphinxtogithub
}

python_install_all() {
	cd share/doc/${PN}/ || die
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}/usr/share/doc/${PF}" \
		prefix="${EPREFIX}/usr" \
		install

	# remove empty bin folder
	rm -R "${ED}"/usr/share/git-cola/bin || die

	use doc || HTML_DOCS=( "${FILESDIR}"/index.html )

	distutils-r1_python_install_all
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
