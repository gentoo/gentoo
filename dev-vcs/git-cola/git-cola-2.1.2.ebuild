# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/git-cola/git-cola-2.1.2.ebuild,v 1.3 2015/05/27 11:10:32 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )
DISTUTILS_SINGLE_IMPL=true

inherit distutils-r1 readme.gentoo virtualx

DESCRIPTION="The highly caffeinated git GUI"
HOMEPAGE="http://git-cola.github.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

REQUIRED_USE="doc? ( python_targets_python2_7 )"

RDEPEND="
	dev-python/jsonpickle[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/PyQt4[${PYTHON_USEDEP}]
	dev-vcs/git"
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
	sys-devel/gettext
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinxtogithub[$(python_gen_usedep 'python2*')]
		)
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		sys-apps/net-tools
		)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.3-disable-tests.patch
	"${FILESDIR}"/${PN}-1.9.1-system-ssh-askpass.patch
	)

pkg_pretend() {
	if use test && [[ -z "$(hostname -d)" ]] ; then
		die "Test will fail if no domain is set"
	fi
}

python_prepare_all() {
	rm share/git-cola/bin/*askpass* || die

	# unfinished translate framework
	rm test/i18n_test.py || die

	# don't install docs into wrong location
	sed -i \
		-e '/doc/d' \
		setup.py || die "sed failed"

	sed -i \
		-e  "s|'doc', 'git-cola'|'doc', '${PF}'|" \
		cola/resources.py || die "sed failed"

	distutils-r1_python_prepare_all
}

python_compile_all() {
	cd share/doc/${PN}/
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
	PYTHONPATH="${S}:${S}/build/lib:${PYTHONPATH}" LC_ALL="C" \
		VIRTUALX_COMMAND="nosetests --verbose \
		--with-id --with-doctest --exclude=sphinxtogithub" \
		virtualmake
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

	python_fix_shebang "${ED}/usr/share/git-cola/bin/git-xbase"
	python_optimize "${ED}/usr/share/git-cola/lib/cola"

	if ! use doc ; then
		HTML_DOCS=( "${FILESDIR}"/index.html )
	fi

	distutils-r1_python_install_all
	readme.gentoo_create_doc
	docompress /usr/share/doc/${PF}/git-cola.txt
}
