# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )
DISTUTILS_SINGLE_IMPL=true

inherit distutils-r1 readme.gentoo-r1 virtualx

DESCRIPTION="The highly caffeinated git GUI"
HOMEPAGE="https://git-cola.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

# Since PyQt5 is preferred at runtime if installed, depend on that
RDEPEND="
	dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	dev-python/QtPy[gui,${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,network,widgets,${PYTHON_USEDEP}]
	dev-vcs/git"
DEPEND="${RDEPEND}
	sys-devel/gettext
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		python_targets_python2_7? ( dev-python/sphinxtogithub[$(python_gen_usedep 'python2*')] )
		)
	test? ( dev-python/nose[${PYTHON_USEDEP}] ${VIRTUALX_DEPEND} )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.10-disable-live-tests.patch
)

python_prepare_all() {
	# Use system QtPy
	rm -r qtpy || die

	rm share/git-cola/bin/*askpass* || die

	# remove broken tests
	rm test/i18n_test.py || die

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
	mydistutilsargs=( --no-vendor-libs )
}

python_compile_all() {
	cd share/doc/${PN}/ || die
	if use doc; then
		emake all
	else
		sed \
			-e '/^install:/s:install-html::g' \
			-e '/^install:/s:install-man::g' \
			-i Makefile || die
	fi
}

python_test() {
	PYTHONPATH="${S}:${S}/build/lib:${PYTHONPATH}" LC_ALL="C" \
	virtx nosetests --verbose --with-id --with-doctest \
		--exclude=sphinxtogithub
}

src_install() {
	distutils-r1_src_install
}

python_install_all() {
	cd share/doc/${PN}/ || die
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}/usr/share/doc/${PF}" \
		prefix="${EPREFIX}/usr" \
		install

	python_fix_shebang "${ED}/usr/share/git-cola/bin/git-xbase" "${ED}"/usr/bin/git-cola
	python_optimize "${ED}/usr/share/git-cola/lib/cola"

	use doc || HTML_DOCS=( "${FILESDIR}"/index.html )

	distutils-r1_python_install_all
	readme.gentoo_create_doc
}
