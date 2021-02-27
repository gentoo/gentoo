# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/pazz/alot/"
	inherit git-r3
else
	SRC_URI="https://github.com/pazz/alot/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Experimental terminal UI for net-mail/notmuch written in Python"
HOMEPAGE="https://github.com/pazz/alot"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-crypt/gpgme[python,${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/urwidtrees[${PYTHON_USEDEP}]
	>=dev-python/twisted-18.4[${PYTHON_USEDEP}]
	net-mail/mailbase
	net-mail/notmuch[crypt,python]
"
DEPEND="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PV}-0001-remove-non-working-test.patch"
	"${FILESDIR}/${PV}-0002-update-reference-to-envelope-body.patch"
)

distutils_enable_tests setup.py

python_compile_all() {
	emake -C docs man
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	doman docs/build/man/*
	distutils-r1_python_install_all

	insinto /usr/share/alot
	doins -r extra
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog ""
		elog "If you are new to Alot you may want to take a look at"
		elog "the user manual:"
		elog "   https://alot.readthedocs.io/en/latest/"
		elog ""
	fi
}
